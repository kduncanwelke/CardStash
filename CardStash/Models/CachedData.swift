//
//  CachedData.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/19/25.
//

import Foundation

struct CachedData {
    static var cards: [Card] = []
    static var cardSets: [CardSets] = []
    static var types: [String] = []
    static var subtypes: [String] = []
    static var superTypes: [String] = []
    static var rarities: [String] = []
    
    static var sorted: [Card] = []
    
    static var selected: Int = 0
    
    // owned cards dictionary for ID and quantity
    static var owned: [String: Int] = [:]
    
    static var faved: [String] = []
}
