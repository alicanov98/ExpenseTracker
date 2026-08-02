//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 30.07.26.
//

import Foundation

struct Expense: Codable {
    let id: UUID
    let title: String
    let category: String
    let amount: Double
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case category
        case amount
        case createdAt = "created_at"
    }
}
