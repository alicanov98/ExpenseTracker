//
//  KeychainManager.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 30.07.26.
//

import Foundation
import Security

final class KeychainManager {

    // MARK: - Singleton

    static let shared = KeychainManager()

    // MARK: - Properties

    private let service = Bundle.main.bundleIdentifier ?? "ExpenseTracker"
    private let tokenAccount = "authToken"

    // MARK: - Initializer

    private init() {}

    // MARK: - Save Token

    @discardableResult
    func saveToken(_ token: String) -> Bool {
        guard let tokenData = token.data(using: .utf8) else {
            return false
        }

        deleteToken()

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: tokenAccount,
            kSecValueData as String: tokenData
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        return status == errSecSuccess
    }

    // MARK: - Read Token

    func readToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: tokenAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?

        let status = SecItemCopyMatching(
            query as CFDictionary,
            &result
        )

        guard
            status == errSecSuccess,
            let tokenData = result as? Data
        else {
            return nil
        }

        return String(data: tokenData, encoding: .utf8)
    }

    // MARK: - Delete Token

    @discardableResult
    func deleteToken() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: tokenAccount
        ]

        let status = SecItemDelete(query as CFDictionary)

        return status == errSecSuccess ||
               status == errSecItemNotFound
    }

    // MARK: - Authentication State

    var isLoggedIn: Bool {
        readToken() != nil
    }
}
