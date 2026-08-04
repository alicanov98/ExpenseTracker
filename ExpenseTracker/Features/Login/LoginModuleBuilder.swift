//
//  LoginModuleBuilder.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 03.08.26.
//

import UIKit

final class LoginModuleBuilder {

    // MARK: - Properties

    private let tokenStorage: TokenStoring

    // MARK: - Initialization

    init(tokenStorage: TokenStoring) {
        self.tokenStorage = tokenStorage
    }

    // MARK: - Build

    func build(
        delegate: LoginViewControllerDelegate
    ) -> UIViewController {
        let viewModel = LoginViewModel(
            tokenStorage: tokenStorage
        )

        let viewController = LoginViewController(
            viewModel: viewModel
        )

        viewController.delegate = delegate

        return viewController
    }
}
