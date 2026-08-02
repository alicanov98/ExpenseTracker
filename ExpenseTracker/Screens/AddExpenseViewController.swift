//
//  AddExpenseViewController.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 30.07.26.
//

import UIKit
import SnapKit

final class AddExpenseViewController: UIViewController {

    // MARK: - Closure

    var onExpenseAdded: (() -> Void)?

    // MARK: - UI Components

    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let categoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Category"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Amount"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()

    private lazy var fieldsStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                titleTextField,
                categoryTextField,
                amountTextField
            ]
        )

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually

        return stackView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - Setup

    private func setupUI() {
        title = "New Expense"
        view.backgroundColor = .systemBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveButtonTapped)
        )

        view.addSubview(fieldsStackView)

        fieldsStackView.snp.makeConstraints { make in
            make.top.equalTo(
                view.safeAreaLayoutGuide.snp.top
            ).offset(24)

            make.horizontalEdges.equalToSuperview().inset(20)
        }

        titleTextField.snp.makeConstraints { make in
            make.height.equalTo(52)
        }

        categoryTextField.snp.makeConstraints { make in
            make.height.equalTo(52)
        }

        amountTextField.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
    }

    // MARK: - Actions

    @objc
    private func saveButtonTapped() {
        view.endEditing(true)

        let title = titleTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let category = categoryTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let amountText = amountTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !title.isEmpty else {
            showAlert(
                title: "Xəbərdarlıq",
                message: "Title boş ola bilməz."
            )
            return
        }

        let normalizedAmount = amountText.replacingOccurrences(
            of: ",",
            with: "."
        )

        guard
            let amount = Double(normalizedAmount),
            amount > 0
        else {
            showAlert(
                title: "Xəbərdarlıq",
                message: "Düzgün amount daxil edin."
            )
            return
        }

        let newExpense = Expense(
            id: UUID(),
            title: title,
            category: category.isEmpty
                ? "Uncategorized"
                : category,
            amount: amount,
            createdAt: Date()
        )

        do {
            var currentExpenses =
                try ExpenseStorageManager.shared.loadExpenses()

            currentExpenses.append(newExpense)

            try ExpenseStorageManager.shared
                .saveExpenses(currentExpenses)

            onExpenseAdded?()

            navigationController?
                .popViewController(animated: true)
        } catch {
            showAlert(
                title: "Xəta",
                message: "Xərc yadda saxlanılmadı."
            )
        }
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
