//
//  ExpensesViewController.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 02.08.26.
//

import UIKit
import SnapKit

final class ExpensesViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: ExpensesViewModelProtocol

    // MARK: - UI Components

    private let tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .insetGrouped
        )
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72
        return tableView
    }()

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Hələ xərc yoxdur"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    // MARK: - Initialization

    init(viewModel: ExpensesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureAppearance()
        configureTableView()
        configureHierarchy()
        configureConstraints()
        bindViewModel()

        viewModel.loadExpenses()
    }

    // MARK: - Configuration

    private func configureAppearance() {
        title = "Expenses"
        view.backgroundColor = .systemBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            ExpensesTableViewCell.self,
            forCellReuseIdentifier: ExpensesTableViewCell.identifier
        )
    }

    private func configureHierarchy() {
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
    }

    private func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }

    private func bindViewModel() {
        viewModel.onExpensesChanged = { [weak self] in
            guard let self else { return }

            self.tableView.reloadData()
            self.emptyStateLabel.isHidden = !self.viewModel.isEmpty
        }

        viewModel.onError = { [weak self] message in
            self?.showAlert(
                title: "Xəta",
                message: message
            )
        }
    }

    // MARK: - Actions

    @objc
    private func addButtonTapped() {
        let addViewModel = AddExpenseViewModel()

        let controller = AddExpenseViewController(
            viewModel: addViewModel
        )

        controller.onExpenseCreated = { [weak self] expense in
            self?.viewModel.addExpense(expense)
        }

        navigationController?.pushViewController(
            controller,
            animated: true
        )
    }
}

// MARK: - UITableViewDataSource

extension ExpensesViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.numberOfExpenses
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ExpensesTableViewCell.identifier,
            for: indexPath
        ) as? ExpensesTableViewCell else {
            return UITableViewCell()
        }

        let expense = viewModel.expense(
            at: indexPath.row
        )

        cell.configure(with: expense)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension ExpensesViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Sil"
        ) { [weak self] _, _, completion in
            self?.viewModel.deleteExpense(
                at: indexPath.row
            )

            completion(true)
        }

        return UISwipeActionsConfiguration(
            actions: [deleteAction]
        )
    }
}
