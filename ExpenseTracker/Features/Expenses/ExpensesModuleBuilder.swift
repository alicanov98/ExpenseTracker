//
//  ExpensesModuleBuilder.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 03.08.26.
//

import UIKit

final class ExpensesModuleBuilder {

    // MARK: - Properties

    private let storage: ExpenseStoring

    // MARK: - Initialization

    init(storage: ExpenseStoring) {
        self.storage = storage
    }

    // MARK: - Build

    func build() -> UIViewController {
        let viewModel = ExpensesViewModel(
            storage: storage
        )

        return ExpensesViewController(
            viewModel: viewModel
        )
    }
}
