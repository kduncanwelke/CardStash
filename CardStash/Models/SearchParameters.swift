//
//  SearchParameters.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/20/25.
//

import Foundation

struct SearchParameters {
    static var name: String = "" // added
    static var pokedexNumber: Int = 0 // added
    static var type: String = "" // added
    static var weakness: String = "" // added
    static var resistance: String = "" // added
    static var retreatCost: Int = -1 // added
    static var cardSet: String = "" // need search?
    static var legality: String = ""
    static var stage: String = "" // added
    static var holo: String = ""
    static var rarity: String = ""
    static var ability: String = "" // need search
    static var move: String = "" // need search
    
    static var sorting: String = ""
    static var searchTerms: String = ""
}

enum Sorting {
    case auto
    case cardSetAZ
    case cardSetZA
    case hpLowHigh
    case hpHighLow
    case nameAZ
    case nameZA
    case numberLowHigh
    case numberHighLow
}
