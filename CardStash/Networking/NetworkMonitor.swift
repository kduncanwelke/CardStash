//
//  NetworkMonitor.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/19/25.
//

import Foundation
import Network

struct NetworkMonitor {
    
    static let monitor = NWPathMonitor()
    static var connection = true
    
    static var status: NetworkStatus = .normal
    
    static var messageShown = false
    
    enum NetworkStatus {
        case normal
        case lost
        case other
    }
}
