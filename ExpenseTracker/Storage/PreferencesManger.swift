//
//  PreferencesManger.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 02.08.26.
//

import Foundation

protocol PreferencesStoring: AnyObject {
    var username: String? { get set }
    var isDarkModeEnabled: Bool { get set }
}

final class PreferencesManager: PreferencesStoring {

    // MARK: - Keys

    private enum Keys {
        static let username = "username"
        static let isDarkModeEnabled = "isDarkModeEnabled"
    }

    // MARK: - Properties

    private let defaults: UserDefaults

    // MARK: - Initialization

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    // MARK: - Username

    var username: String? {
        get {
            defaults.string(
                forKey: Keys.username
            )
        }

        set {
            defaults.set(
                newValue,
                forKey: Keys.username
            )
        }
    }

    // MARK: - Dark Mode

    var isDarkModeEnabled: Bool {
        get {
            defaults.bool(
                forKey: Keys.isDarkModeEnabled
            )
        }

        set {
            defaults.set(
                newValue,
                forKey: Keys.isDarkModeEnabled
            )
        }
    }
}
