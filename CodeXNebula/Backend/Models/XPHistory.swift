//
//  XPHistory.swift
//  CodeXNebula
//

import Foundation

struct XPHistory: Identifiable, Hashable {
    let id: String
    let amount: Int
    let reason: String
    let date: Date
}
