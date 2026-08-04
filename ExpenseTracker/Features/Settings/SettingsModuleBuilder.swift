//
//  SettingsModuleBuilder.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 03.08.26.
//

import UIKit

final class SettingsModuleBuilder {

    // MARK: - Properties

    private let preferences: PreferencesStoring
    private let tokenStorage: TokenStoring

    // MARK: - Initialization

    init(
        preferences: PreferencesStoring,
        tokenStorage: TokenStoring
    ) {
        self.preferences = preferences
        self.tokenStorage = tokenStorage
    }

    // MARK: - Build

    func build(
        delegate: SettingsViewControllerDelegate
    ) -> UIViewController {
        let viewModel = SettingsViewModel(
            preferences: preferences,
            tokenStorage: tokenStorage
        )

        let viewController = SettingsViewController(
            viewModel: viewModel
        )

        viewController.delegate = delegate

        return viewController
    }
}
