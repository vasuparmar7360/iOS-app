//
//  BattleTimer.swift
//  CodeXNebula
//

import Foundation

struct BattleTimer: Hashable {
    var remainingSeconds: Int
    var totalSeconds: Int
    
    var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return Double(remainingSeconds) / Double(totalSeconds)
    }
    
    var timeString: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
