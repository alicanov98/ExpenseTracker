//
//  MainTabBarController.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 30.07.26.
//

import UIKit


final class MainTabBarController: UITabBarController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
        setupViewControllers()
    }

    // MARK: - Setup

    private func setupTabBar() {
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .systemBackground
    }

    private func setupViewControllers() {
        let expensesViewController =
            ExpensesViewController()

        let expensesNavigationController =
            UINavigationController(
                rootViewController: expensesViewController
            )

        expensesNavigationController.tabBarItem =
            UITabBarItem(
                title: "Expenses",
                image: UIImage(
                    systemName: "list.bullet.rectangle"
                ),
                selectedImage: UIImage(
                    systemName: "list.bullet.rectangle.fill"
                )
            )

        let settingsViewController =
            SettingsViewController()

        let settingsNavigationController =
            UINavigationController(
                rootViewController: settingsViewController
            )

        settingsNavigationController.tabBarItem =
            UITabBarItem(
                title: "Settings",
                image: UIImage(
                    systemName: "gearshape"
                ),
                selectedImage: UIImage(
                    systemName: "gearshape.fill"
                )
            )

        viewControllers = [
            expensesNavigationController,
            settingsNavigationController
        ]
    }
}
