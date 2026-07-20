//
//  LevelSystem.swift
//  CodeXNebula
//

import Foundation

struct LevelSystem {
    static func level(for xp: Int) -> Int {
        if xp < 200 { return 1 }
        else if xp < 500 { return 2 }
        else if xp < 1000 { return 3 }
        else {
            return 3 + (xp - 1000) / 1000
        }
    }
    
    static func xpRequired(for level: Int) -> Int {
        if level == 1 { return 0 }
        if level == 2 { return 200 }
        if level == 3 { return 500 }
        return 1000 + (level - 3) * 1000
    }
    
    static func progress(for xp: Int) -> Double {
        let currentLvl = level(for: xp)
        let xpForCurrent = xpRequired(for: currentLvl)
        let xpForNext = xpRequired(for: currentLvl + 1)
        
        let diff = Double(xp - xpForCurrent)
        let totalNeeded = Double(xpForNext - xpForCurrent)
        
        guard totalNeeded > 0 else { return 1.0 }
        return diff / totalNeeded
    }
}
