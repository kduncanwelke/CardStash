//
//  SearchParameters.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/20/25.
//

import Foundation

struct SearchParameters {
    static var name: String = ""
    static var pokedexNumber: Int = 0
    static var type: String = ""
    static var weakness: String = ""
    static var resistance: String = ""
    static var retreatCost: Int = -1
    static var cardSet: String = ""
    static var legality: String = ""
    static var stage: String = ""
    static var holo: String = ""
    static var rarity: String = ""
    static var superType: String = ""
    
    static var sorting: String = ""
    static var sortingKind: Sorting = .auto
    static var isNewSearch: Bool = false
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
