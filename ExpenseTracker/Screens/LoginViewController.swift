//
//  LoginViewController.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 30.07.26.
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Expense Tracker"
        label.font = .systemFont(
            ofSize: 30,
            weight: .bold
        )
        label.textAlignment = .center
        return label
    }()

    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
        textField.delegate = self
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)

        var configuration = UIButton.Configuration.filled()
        configuration.title = "Login"
        configuration.cornerStyle = .medium

        button.configuration = configuration

        button.addTarget(
            self,
            action: #selector(loginButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var formStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                usernameTextField,
                passwordTextField,
                loginButton
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
        view.backgroundColor = .systemBackground

        navigationItem.backButtonDisplayMode = .minimal

        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(formStackView)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(
                view.safeAreaLayoutGuide.snp.top
            ).offset(80)

            make.horizontalEdges.equalToSuperview().inset(24)
        }

        formStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(24)
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

    // MARK: - Actions

    @objc
    private func loginButtonTapped() {
        view.endEditing(true)

        let username = usernameTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let password = passwordTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !username.isEmpty, !password.isEmpty else {
            showAlert(
                title: "Xəbərdarlıq",
                message: "Username və password boş ola bilməz."
            )
            return
        }

        let token = UUID().uuidString
        let tokenSaved = KeychainManager.shared.saveToken(token)

        guard tokenSaved else {
            showAlert(
                title: "Xəta",
                message: "Token Keychain-də saxlanılmadı."
            )
            return
        }

        UserDefaults.standard.set(
            username,
            forKey: "username"
        )

        AppRouter.showMainApp()
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

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        if textField === usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginButtonTapped()
        }

        return true
    }
}
