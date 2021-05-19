//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Simon Bogutzky on 24.10.20.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
}
