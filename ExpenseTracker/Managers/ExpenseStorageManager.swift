//
//  ExpenseStorageManager.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 30.07.26.
//

import Foundation

final class ExpenseStorageManager {

    // MARK: - Singleton

    static let shared = ExpenseStorageManager()

    // MARK: - Properties

    private let fileName = "expenses.json"

    private var fileURL: URL {
        FileManager.default
            .urls(
                for: .documentDirectory,
                in: .userDomainMask
            )[0]
            .appendingPathComponent(fileName)
    }

    // MARK: - Initializer

    private init() {}

    // MARK: - Save Expenses

    func saveExpenses(_ expenses: [Expense]) throws {
        let encoder = JSONEncoder()

        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [
            .prettyPrinted,
            .sortedKeys
        ]

        let data = try encoder.encode(expenses)

        try data.write(
            to: fileURL,
            options: .atomic
        )
    }

    // MARK: - Load Expenses

    func loadExpenses() throws -> [Expense] {
        guard FileManager.default.fileExists(
            atPath: fileURL.path
        ) else {
            return []
        }

        let data = try Data(contentsOf: fileURL)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode(
            [Expense].self,
            from: data
        )
    }
}
