//
//  CodeMetrics.swift
//  CodeXNebula
//

import Foundation

struct CodeMetrics: Hashable {
    let correctness: Int
    let performance: Int
    let readability: Int
    let optimization: Int
    let speed: Int
    let style: Int
    
    var totalScore: Int {
        return correctness + performance + readability + optimization + speed + style
    }
}
