//
//  ExpenseStorage.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 02.08.26.
//

import Foundation

protocol ExpenseStoring {
    func loadExpenses() throws -> [Expense]
    func saveExpenses(_ expenses: [Expense]) throws
}

final class LocalExpenseStorage: ExpenseStoring {
    
    private var expensesFileURL: URL {
        let documentsFolder = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask
        )[0]
        return documentsFolder.appendingPathComponent("expenses.json")
    }
    
    func loadExpenses() throws -> [Expense] {
        guard FileManager.default.fileExists(
            atPath: expensesFileURL.path
        ) else {
            return []
        }
        
        let data = try Data(contentsOf: expensesFileURL)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode([Expense].self, from: data)
    }
    
    func saveExpenses(_ expenses: [Expense]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        
        let data = try encoder.encode(expenses)
        
        try data.write(
            to: expensesFileURL,
            options: .atomic
        )
    }
    
    
}
