//
//  AppRouter.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 30.07.26.
//

import UIKit

enum AppRouter {

    // MARK: - Show Login

    static func showLogin() {
        guard let window = activeWindow else {
            return
        }

        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(
            rootViewController: loginViewController
        )

        changeRootViewController(
            to: navigationController,
            in: window
        )
    }

    // MARK: - Show Main Application

    static func showMainApp() {
        guard let window = activeWindow else {
            return
        }

        let tabBarController = MainTabBarController()

        changeRootViewController(
            to: tabBarController,
            in: window
        )
    }

    // MARK: - Active Window

    private static var activeWindow: UIWindow? {
        let scenes = UIApplication.shared.connectedScenes

        let windowScene = scenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }

        return windowScene?
            .windows
            .first { $0.isKeyWindow }
    }

    // MARK: - Change Root

    private static func changeRootViewController(
        to viewController: UIViewController,
        in window: UIWindow
    ) {
        window.rootViewController = viewController

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
}
