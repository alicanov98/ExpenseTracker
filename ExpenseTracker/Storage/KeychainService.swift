//
//  KeychainService.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 02.08.26.
//

import Foundation
import Security

protocol TokenStoring {
    func saveToken(_ token: String) throws
    func readToken() throws -> String?
    func deleteToken() throws
}

enum KeychainError: LocalizedError {
    case invalidData
    case unexpectedStatus(OSStatus)

    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Token məlumatı düzgün formatda deyil."

        case .unexpectedStatus(let status):
            return "Keychain əməliyyatı uğursuz oldu. Status: \(status)"
        }
    }
}

final class KeychainService: TokenStoring {

    // MARK: - Keys

    private enum Keys {
        static let account = "authToken"
    }

    // MARK: - Properties

    private let service: String

    // MARK: - Initialization

    init(
        service: String = Bundle.main.bundleIdentifier
            ?? "ExpenseTracker"
    ) {
        self.service = service
    }

    // MARK: - Save

    func saveToken(_ token: String) throws {
        guard let data = token.data(using: .utf8) else {
            throw KeychainError.invalidData
        }

        let query: [String: Any] = [
            kSecClass as String:
                kSecClassGenericPassword,

            kSecAttrService as String:
                service,

            kSecAttrAccount as String:
                Keys.account,

            kSecValueData as String:
                data,

            kSecAttrAccessible as String:
                kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        let status = SecItemAdd(
            query as CFDictionary,
            nil
        )

        if status == errSecDuplicateItem {
            try updateToken(with: data)
            return
        }

        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }

    // MARK: - Read

    func readToken() throws -> String? {
        let query: [String: Any] = [
            kSecClass as String:
                kSecClassGenericPassword,

            kSecAttrService as String:
                service,

            kSecAttrAccount as String:
                Keys.account,

            kSecReturnData as String:
                true,

            kSecMatchLimit as String:
                kSecMatchLimitOne
        ]

        var result: AnyObject?

        let status = SecItemCopyMatching(
            query as CFDictionary,
            &result
        )

        if status == errSecItemNotFound {
            return nil
        }

        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }

        guard let data = result as? Data,
              let token = String(
                data: data,
                encoding: .utf8
              ) else {
            throw KeychainError.invalidData
        }

        return token
    }

    // MARK: - Delete

    func deleteToken() throws {
        let query: [String: Any] = [
            kSecClass as String:
                kSecClassGenericPassword,

            kSecAttrService as String:
                service,

            kSecAttrAccount as String:
                Keys.account
        ]

        let status = SecItemDelete(
            query as CFDictionary
        )

        guard status == errSecSuccess ||
              status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }

    // MARK: - Update

    private func updateToken(with data: Data) throws {
        let query: [String: Any] = [
            kSecClass as String:
                kSecClassGenericPassword,

            kSecAttrService as String:
                service,

            kSecAttrAccount as String:
                Keys.account
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]

        let status = SecItemUpdate(
            query as CFDictionary,
            attributes as CFDictionary
        )

        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
}
