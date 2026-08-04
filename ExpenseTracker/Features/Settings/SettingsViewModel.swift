//
//  SettingsViewModel.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 02.08.26.
//

import Foundation

protocol SettingsViewModelProtocol: AnyObject {

    // MARK: - Outputs

    var onThemeChanged: ((Bool) -> Void)? { get set }
    var onLogoutSuccess: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }

    // MARK: - Data

    var username: String { get }
    var usernameInitial: String { get }
    var isDarkModeEnabled: Bool { get }

    // MARK: - Actions

    func updateDarkMode(isEnabled: Bool)
    func logout()
}

final class SettingsViewModel: SettingsViewModelProtocol {

    // MARK: - Properties

    private let preferences: PreferencesStoring
    private let tokenStorage: TokenStoring

    // MARK: - Outputs

    var onThemeChanged: ((Bool) -> Void)?
    var onLogoutSuccess: (() -> Void)?
    var onError: ((String) -> Void)?

    // MARK: - Initialization

    init(
        preferences: PreferencesStoring,
        tokenStorage: TokenStoring
    ) {
        self.preferences = preferences
        self.tokenStorage = tokenStorage
    }

    // MARK: - Computed Properties

    var username: String {
        preferences.username ?? "User"
    }

    var usernameInitial: String {
        String(username.prefix(1)).uppercased()
    }

    var isDarkModeEnabled: Bool {
        preferences.isDarkModeEnabled
    }

    // MARK: - Public Methods

    func updateDarkMode(isEnabled: Bool) {
        preferences.isDarkModeEnabled = isEnabled
        onThemeChanged?(isEnabled)
    }

    func logout() {
        do {
            try tokenStorage.deleteToken()
            preferences.username = nil
            onLogoutSuccess?()
        } catch {
            onError?(error.localizedDescription)
        }
    }
}
