//
//  ThemeManager.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 30.07.26.
//

import UIKit

final class ThemeManager {

    // MARK: - Singleton

    static let shared = ThemeManager()

    // MARK: - Properties

    private let darkModeKey = "isDarkModeEnabled"

    var isDarkModeEnabled: Bool {
        get {
            UserDefaults.standard.bool(
                forKey: darkModeKey
            )
        }

        set {
            UserDefaults.standard.set(
                newValue,
                forKey: darkModeKey
            )
        }
    }

    // MARK: - Initializer

    private init() {}

    // MARK: - Apply Theme

    func applyTheme(to window: UIWindow?) {
        window?.overrideUserInterfaceStyle =
            isDarkModeEnabled ? .dark : .light
    }
}
