//
//  Chapter.swift
//  CodeXNebula
//

import Foundation

struct Chapter: Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let languageId: String
    let sortOrder: Int
}
