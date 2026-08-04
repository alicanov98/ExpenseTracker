//
//  LoginViewModel.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 02.08.26.
//

import Foundation

enum LoginError: LocalizedError {
    case emptyUsername
    case emptyPassword

    var errorDescription: String? {
        switch self {
        case .emptyUsername:
            return "Username boş ola bilməz."

        case .emptyPassword:
            return "Password boş ola bilməz."
        }
    }
}

protocol LoginViewModelProtocol: AnyObject {

    // MARK: - Outputs

    var onLoginSuccess: ((String) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }

    // MARK: - Actions

    func login(
        username: String?,
        password: String?
    )
}

final class LoginViewModel: LoginViewModelProtocol {

    // MARK: - Properties

    private let tokenStorage: TokenStoring

    // MARK: - Outputs

    var onLoginSuccess: ((String) -> Void)?
    var onError: ((String) -> Void)?

    // MARK: - Initialization

    init(tokenStorage: TokenStoring) {
        self.tokenStorage = tokenStorage
    }

    // MARK: - Public Methods

    func login(
        username: String?,
        password: String?
    ) {
        do {
            let validUsername = try validateUsername(username)
            try validatePassword(password)

            let token = UUID().uuidString
            try tokenStorage.saveToken(token)

            onLoginSuccess?(validUsername)
        } catch {
            onError?(error.localizedDescription)
        }
    }

    // MARK: - Validation

    private func validateUsername(
        _ username: String?
    ) throws -> String {
        let trimmedUsername = username?
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            ) ?? ""

        guard !trimmedUsername.isEmpty else {
            throw LoginError.emptyUsername
        }

        return trimmedUsername
    }

    private func validatePassword(
        _ password: String?
    ) throws {
        let trimmedPassword = password?
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            ) ?? ""

        guard !trimmedPassword.isEmpty else {
            throw LoginError.emptyPassword
        }
    }
}
