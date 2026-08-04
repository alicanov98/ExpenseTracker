//
//  SceneDelegate.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 02.08.26.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties

    var window: UIWindow?

    // MARK: - Scene Lifecycle

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        // MARK: Dependencies

        let tokenStorage = KeychainService()
        let preferences = PreferencesManager()
        let expenseStorage = LocalExpenseStorage()

        // MARK: Root Controller

        let rootViewController = RootViewController(
            tokenStorage: tokenStorage,
            preferences: preferences,
            expenseStorage: expenseStorage
        )

        // MARK: Window

        let window = UIWindow(
            windowScene: windowScene
        )

        window.rootViewController = rootViewController

        window.overrideUserInterfaceStyle =
            preferences.isDarkModeEnabled
            ? .dark
            : .light

        window.makeKeyAndVisible()

        self.window = window
    }
}
