//
//  Types.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/19/25.
//

import Foundation

struct Types: Codable, SearchType {
    static var endpoint = Endpoint.types
    var data: [String]
}

struct SubTypes: Codable, SearchType {
    static var endpoint = Endpoint.subTypes
    var data: [String]
}

struct SuperTypes: Codable, SearchType {
    static var endpoint = Endpoint.superTypes
    var data: [String]
}

struct Rarities: Codable, SearchType {
    static var endpoint = Endpoint.rarities
    var data: [String]
}
