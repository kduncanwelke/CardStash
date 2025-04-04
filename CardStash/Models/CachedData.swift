//
//  CachedData.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/19/25.
//

import Foundation

struct CachedData {
    static var cards: [Card] = []
    static var cardSets: [CardSet] = []
    static var types: [String] = []
    static var subtypes: [String] = []
    static var superTypes: [String] = []
    static var rarities: [String] = []
    
    static var sorted: [Card] = []
    
    static var indexPath: IndexPath?
    static var selected: Int = 0
    
    // dictionaries (for fast lookup) and arrays (for sorting) for owned and favorited cards
    static var owned: [String: Int] = [:]
    static var ownedCards: [Card] = []
    static var sortedOwned: [Card] = []
    
    static var faved: [String: String] = [:]
    static var faveCards: [Card] = []
    static var sortedFaves: [Card] = []
    
    static var currentCardType: SelectedCards = .all
}

enum SelectedCards {
    case all
    case allSorted
    case owned
    case ownedSorted
    case faves
    case favesSorted
}
