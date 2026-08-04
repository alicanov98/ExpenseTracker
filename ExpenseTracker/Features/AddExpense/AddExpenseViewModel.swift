//
//  AddExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 02.08.26.
//

import Foundation

enum AddExpenseError: LocalizedError {
    case emptyTitle
    case invalidAmount

    var errorDescription: String? {
        switch self {
        case .emptyTitle:
            return "Title boş ola bilməz."

        case .invalidAmount:
            return "Düzgün məbləğ daxil edin."
        }
    }
}

protocol AddExpenseViewModelProtocol {
    func createExpense(
        title: String?,
        category: String?,
        amountText: String?
    ) throws -> Expense
}

final class AddExpenseViewModel: AddExpenseViewModelProtocol {

    // MARK: - Public Methods

    func createExpense(
        title: String?,
        category: String?,
        amountText: String?
    ) throws -> Expense {
        let trimmedTitle = title?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !trimmedTitle.isEmpty else {
            throw AddExpenseError.emptyTitle
        }

        let trimmedCategory = category?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let finalCategory = trimmedCategory.isEmpty
            ? "Other"
            : trimmedCategory

        let trimmedAmount = amountText?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let normalizedAmount = trimmedAmount.replacingOccurrences(
            of: ",",
            with: "."
        )

        guard let amount = Double(normalizedAmount),
              amount > 0 else {
            throw AddExpenseError.invalidAmount
        }

        return Expense(
            id: UUID(),
            title: trimmedTitle,
            category: finalCategory,
            amount: amount,
            createdAt: Date()
        )
    }
}
