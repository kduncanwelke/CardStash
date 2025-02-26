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
    static var cardSet: String = ""
    static var legality: String = "" // added
    static var stage: String = "" // added
    static var holo: String = "" // added
    static var rarity: String = "" // added
    static var ability: String = ""
    static var move: String = ""
    static var superType: String = "" // added
    
    static var sorting: String = ""
    static var sortingKind: Sorting = .auto
    static var isNewSearch: Bool = true
    static var searchTerms: String = ""
    
    static var prevSearch: String = ""
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

enum PokemonType {
    case any
    case colorless
    case fire
    case lightning
    case grass
    case water
    case psychic
    case darkness
    case fairy
    case dragon
    case metal
    case fighting
}

enum PokemonStage {
    case any
    case baby
    case basic
    case stage1
    case stage2
}

enum CardType {
    case any
    case pokemon
    case energy
    case trainer
}

enum HoloType {
    case any
    case holo
    case notHolo
}

enum Rarity {
    case any
    case common
    case uncommon
    case rare
    case promo
    case legend
}

enum Legality {
    case any
    case standard
    case expanded
    case unlimited
}
