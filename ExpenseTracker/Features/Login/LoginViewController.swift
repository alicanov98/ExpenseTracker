//
//  LoginViewController.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 02.08.26.
//

import UIKit
import SnapKit

protocol LoginViewControllerDelegate: AnyObject {
    func loginViewController(
        _ controller: LoginViewController,
        didLoginWithUsername username: String
    )
}

final class LoginViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: LoginViewModelProtocol

    weak var delegate: LoginViewControllerDelegate?

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Expense Tracker"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Xərclərinizi idarə etmək üçün daxil olun"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        return textField
    }()

    private let loginButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Login"
        configuration.cornerStyle = .large
        return UIButton(configuration: configuration)
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                subtitleLabel,
                usernameTextField,
                passwordTextField,
                loginButton
            ]
        )

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill

        stackView.setCustomSpacing(
            8,
            after: titleLabel
        )

        stackView.setCustomSpacing(
            32,
            after: subtitleLabel
        )

        return stackView
    }()

    // MARK: - Initialization

    init(viewModel: LoginViewModelProtocol) {
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
        configureActions()
        configureHierarchy()
        configureConstraints()
        configureKeyboardDismiss()
        bindViewModel()
    }

    // MARK: - Configuration

    private func configureAppearance() {
        view.backgroundColor = .systemBackground
    }

    private func configureTextFields() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }

    private func configureActions() {
        loginButton.addTarget(
            self,
            action: #selector(loginButtonTapped),
            for: .touchUpInside
        )
    }

    private func configureHierarchy() {
        view.addSubview(contentStackView)
    }

    private func configureConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }

        usernameTextField.snp.makeConstraints { make in
            make.height.equalTo(52)
        }

        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(52)
        }

        loginButton.snp.makeConstraints { make in
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

    private func bindViewModel() {
        viewModel.onLoginSuccess = { [weak self] username in
            guard let self else { return }

            self.delegate?.loginViewController(
                self,
                didLoginWithUsername: username
            )
        }

        viewModel.onError = { [weak self] message in
            self?.showAlert(
                title: "Login xətası",
                message: message
            )
        }
    }

    // MARK: - Actions

    @objc
    private func loginButtonTapped() {
        view.endEditing(true)

        viewModel.login(
            username: usernameTextField.text,
            password: passwordTextField.text
        )
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        if textField === usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField === passwordTextField {
            view.endEditing(true)

            viewModel.login(
                username: usernameTextField.text,
                password: passwordTextField.text
            )
        }

        return true
    }
}
