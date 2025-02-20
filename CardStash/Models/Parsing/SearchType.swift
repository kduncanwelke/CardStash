//
//  SearchType.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/19/25.
//

import Foundation

// protocol for search types, used for generics in data manager
protocol SearchType: Decodable {
    static var endpoint: Endpoint { get }
}
