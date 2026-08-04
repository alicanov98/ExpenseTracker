//
//  ExpensesViewModel.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 02.08.26.
//

import Foundation

protocol ExpensesViewModelProtocol: AnyObject {
    var onExpensesChanged: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    
    var numberOfExpenses: Int { get }
    var isEmpty: Bool { get }
    
    func expense(at index: Int) -> Expense
    func loadExpenses()
    func addExpense(_ expense: Expense)
    func deleteExpense(at index: Int)
}

final class ExpensesViewModel: ExpensesViewModelProtocol {

    // MARK: - Properties

    private var expenses: [Expense] = []
    private let storage: ExpenseStoring
    
    // MARK: - Initializer
    
    init(storage: ExpenseStoring) {
        self.storage = storage
    }
    
    // MARK: - Outputs
    var onExpensesChanged: (() -> Void)?
    
    var onError: ((String) -> Void)?
    
    // MARK: - Computed property
    
    var numberOfExpenses: Int {
        expenses.count
    }
    
    var isEmpty: Bool {
        expenses.isEmpty
    }
    
    func expense(at index: Int) -> Expense {
        expenses[index]
    }
    
    func loadExpenses() {
        do {
            expenses = try storage.loadExpenses()
            onExpensesChanged?()
        } catch {
            onError?(error.localizedDescription)
        }
    }
    
    func addExpense(_ expense: Expense) {
        var updatedExpenses = expenses
        updatedExpenses.append(expense)
        
        do {
            try storage.saveExpenses(expenses)
            expenses = updatedExpenses
            onExpensesChanged?()
        } catch {
            onError?(error.localizedDescription)
        }
    }
    
    func deleteExpense(at index: Int) {
        guard expenses.indices.contains(index) else {
            return
        }
        
        var updatedExpenses = expenses
        updatedExpenses.remove(at: index)
        
        do {
            try storage.saveExpenses(updatedExpenses)
            expenses = updatedExpenses
            onExpensesChanged?()
        }catch {
            onError?(error.localizedDescription)
        }
    }
    
    
}
