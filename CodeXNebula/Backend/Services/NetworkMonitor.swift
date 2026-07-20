//
//  NetworkMonitor.swift
//  CodeXNebula
//

import Foundation
import Network

@MainActor
class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    
    @Published var isConnected: Bool = true
    @Published var isExpensive: Bool = false
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                let wasDisconnected = !(self?.isConnected ?? true)
                let isNowConnected = path.status == .satisfied
                
                self?.isConnected = isNowConnected
                self?.isExpensive = path.isExpensive
                
                if wasDisconnected && isNowConnected {
                    SyncService.shared.startSync()
                }
            }
        }
        monitor.start(queue: queue)
    }
}
