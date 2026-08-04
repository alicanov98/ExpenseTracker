import UIKit
import SnapKit

final class AddExpenseViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: AddExpenseViewModelProtocol

    // MARK: - Outputs

    var onExpenseCreated: ((Expense) -> Void)?

    // MARK: - UI Components

    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .sentences
        textField.returnKeyType = .next
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    private let categoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Category"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .words
        textField.returnKeyType = .next
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Amount"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numbersAndPunctuation
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    private lazy var formStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                titleTextField,
                categoryTextField,
                amountTextField
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()

    // MARK: - Initialization

    init(viewModel: AddExpenseViewModelProtocol) {
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
        configureTextFields()
        configureHierarchy()
        configureConstraints()
        configureKeyboardDismiss()
    }

    // MARK: - Configuration

    private func configureAppearance() {
        title = "New Expense"
        view.backgroundColor = .systemBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveButtonTapped)
        )
    }

    private func configureTextFields() {
        titleTextField.delegate = self
        categoryTextField.delegate = self
        amountTextField.delegate = self
    }

    private func configureHierarchy() {
        view.addSubview(formStackView)
    }

    private func configureConstraints() {
        formStackView.snp.makeConstraints { make in
            make.top.equalTo(
                view.safeAreaLayoutGuide.snp.top
            ).offset(24)

            make.leading.trailing.equalToSuperview().inset(20)
        }

        titleTextField.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
    }

    private func configureKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )

        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - Actions

    @objc
    private func saveButtonTapped() {
        do {
            let expense = try viewModel.createExpense(
                title: titleTextField.text,
                category: categoryTextField.text,
                amountText: amountTextField.text
            )

            onExpenseCreated?(expense)

            navigationController?.popViewController(
                animated: true
            )
        } catch {
            showAlert(
                title: "Xəta",
                message: error.localizedDescription
            )
        }
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension AddExpenseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        if textField === titleTextField {
            categoryTextField.becomeFirstResponder()
        } else if textField === categoryTextField {
            amountTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }
}
