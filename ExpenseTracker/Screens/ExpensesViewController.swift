//
//  ExpensesViewController.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 30.07.26.
//

import UIKit
import SnapKit

final class ExpensesViewController: UIViewController {

    // MARK: - Data

    private var expenses: [Expense] = []

    // MARK: - UI Components

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Hələ xərc yoxdur"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .plain
        )

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70

        tableView.register(
            ExpenseTableViewCell.self,
            forCellReuseIdentifier: ExpenseTableViewCell.identifier
        )

        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadExpenses()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadExpenses()
    }

    // MARK: - Setup

    private func setupUI() {
        title = "Expenses"
        view.backgroundColor = .systemBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )

        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }

    // MARK: - Load Expenses

    private func loadExpenses() {
        do {
            expenses = try ExpenseStorageManager.shared
                .loadExpenses()

            expenses.sort {
                $0.createdAt > $1.createdAt
            }

            tableView.reloadData()
            updateEmptyState()
        } catch {
            showAlert(
                title: "Xəta",
                message: "Xərclər oxunmadı: \(error.localizedDescription)"
            )
        }
    }

    // MARK: - Save Expenses

    private func saveExpenses() {
        do {
            try ExpenseStorageManager.shared
                .saveExpenses(expenses)
        } catch {
            showAlert(
                title: "Xəta",
                message: "Dəyişiklik yadda saxlanılmadı."
            )
        }
    }

    // MARK: - Empty State

    private func updateEmptyState() {
        let isEmpty = expenses.isEmpty

        emptyStateLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }

    // MARK: - Actions

    @objc
    private func addButtonTapped() {
        let addExpenseViewController =
            AddExpenseViewController()

        addExpenseViewController.onExpenseAdded = {
            [weak self] in

            self?.loadExpenses()
        }

        navigationController?.pushViewController(
            addExpenseViewController,
            animated: true
        )
    }

    // MARK: - Alert

    private func showAlert(
        title: String,
        message: String
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )

        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ExpensesViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        expenses.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ExpenseTableViewCell.identifier,
            for: indexPath
        ) as? ExpenseTableViewCell else {
            return UITableViewCell()
        }

        let expense = expenses[indexPath.row]

        cell.configure(with: expense)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension ExpensesViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else {
            return
        }

        expenses.remove(at: indexPath.row)

        do {
            try ExpenseStorageManager.shared
                .saveExpenses(expenses)

            tableView.deleteRows(
                at: [indexPath],
                with: .automatic
            )

            updateEmptyState()
        } catch {
            loadExpenses()

            showAlert(
                title: "Xəta",
                message: "Xərc silinmədi."
            )
        }
    }

    func tableView(
        _ tableView: UITableView,
        titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath
    ) -> String? {
        "Sil"
    }
}
