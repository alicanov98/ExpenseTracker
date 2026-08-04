//
//  RootViewController.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 02.08.26.
//

import UIKit

final class RootViewController: UIViewController {

    // MARK: - Dependencies

    private let tokenStorage: TokenStoring
    private let preferences: PreferencesStoring
    private let expenseStorage: ExpenseStoring

    // MARK: - Properties

    private var currentController: UIViewController?

    // MARK: - Initialization

    init(
        tokenStorage: TokenStoring,
        preferences: PreferencesStoring,
        expenseStorage: ExpenseStoring
    ) {
        self.tokenStorage = tokenStorage
        self.preferences = preferences
        self.expenseStorage = expenseStorage

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        checkAuthenticationState()
    }

    // MARK: - Authentication

    private func checkAuthenticationState() {
        do {
            let token = try tokenStorage.readToken()

            if token == nil {
                showLogin()
            } else {
                showMainApplication()
            }
        } catch {
            showLogin()

            DispatchQueue.main.async { [weak self] in
                self?.showAlert(
                    title: "Keychain xətası",
                    message: error.localizedDescription
                )
            }
        }
    }

    // MARK: - Navigation

    private func showLogin() {
        let loginController = LoginModuleBuilder(
            tokenStorage: tokenStorage
        ).build(delegate: self)

        replaceCurrentController(
            with: loginController
        )
    }

    private func showMainApplication() {
        let expensesController = ExpensesModuleBuilder(
            storage: expenseStorage
        ).build()

        let expensesNavigationController =
            UINavigationController(
                rootViewController: expensesController
            )

        expensesNavigationController.tabBarItem = UITabBarItem(
            title: "Expenses",
            image: UIImage(
                systemName: "list.bullet.rectangle"
            ),
            selectedImage: UIImage(
                systemName: "list.bullet.rectangle.fill"
            )
        )

        let settingsController = SettingsModuleBuilder(
            preferences: preferences,
            tokenStorage: tokenStorage
        ).build(delegate: self)

        let settingsNavigationController =
            UINavigationController(
                rootViewController: settingsController
            )

        settingsNavigationController.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(
                systemName: "gearshape"
            ),
            selectedImage: UIImage(
                systemName: "gearshape.fill"
            )
        )

        let tabBarController = UITabBarController()

        tabBarController.viewControllers = [
            expensesNavigationController,
            settingsNavigationController
        ]

        replaceCurrentController(
            with: tabBarController
        )
    }

    // MARK: - Child Controller Management

    private func replaceCurrentController(
        with newController: UIViewController
    ) {
        removeCurrentController()
        addNewController(newController)
        currentController = newController
    }

    private func removeCurrentController() {
        guard let currentController else {
            return
        }

        currentController.willMove(
            toParent: nil
        )

        currentController.view.removeFromSuperview()
        currentController.removeFromParent()
    }

    private func addNewController(
        _ controller: UIViewController
    ) {
        addChild(controller)

        controller.view.frame = view.bounds

        controller.view.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]

        view.addSubview(controller.view)

        controller.didMove(toParent: self)
    }
}

// MARK: - LoginViewControllerDelegate

extension RootViewController:
    LoginViewControllerDelegate {

    func loginViewController(
        _ controller: LoginViewController,
        didLoginWithUsername username: String
    ) {
        preferences.username = username
        showMainApplication()
    }
}

// MARK: - SettingsViewControllerDelegate

extension RootViewController:
    SettingsViewControllerDelegate {

    func settingsViewControllerDidLogout(
        _ controller: SettingsViewController
    ) {
        showLogin()
    }
}

