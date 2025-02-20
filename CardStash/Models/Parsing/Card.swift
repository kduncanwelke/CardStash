//
//  Card.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/19/25.
//

import Foundation

struct Cards: SearchType {
    static var endpoint = Endpoint.cards
    var data: [Card]
}

struct Card: Codable {
    var id: String?
    var name: String?
    var supertype: String?
    var subtypes: [String]?
    var hp: String?
    var types: [String]?
    var evolvesFrom: String?
    var evolvesTo: [String]?
    var abilities: [Ability]?
    var attacks: [Attack]?
    var weaknesses: [Weakness]?
    var resistances: [Resistance]?
    var retreatCost: [String]?
    var convertedRetreatCost: Int?
    var set: Set?
    var number: String?
    var rarity: String?
    var flavorText: String?
    var nationalPokedexNumbers: [Int]?
    var rules: [String]?
    var legalities: Legalities?
    var images: CardImages?
    var tcgplayer: TCGPlayer?
}

struct Ability: Codable {
    var name: String
    var text: String
    var type: String
}

struct Attack: Codable {
    var name: String
    var cost: [String]?
    var convertedEnergyCost: Int?
    var damage: String?
    var text: String?
}

struct Weakness: Codable {
    var type: String
    var value: String
}

struct Resistance: Codable {
    var type: String
    var value: String
}

struct Set: Codable {
    var id: String
    var name: String
    var series: String
    var images: SetImage
}

struct SetImage: Codable {
    var symbol: String
    var logo: String
}

struct Legalities: Codable {
    var unlimited: String?
    var standard: String?
    var expanded: String?
}

struct CardImages: Codable {
    var small: String
    var large: String
}

struct TCGPlayer: Codable {
    var updatedAt: String?
    var prices: Price?
}

struct Price: Codable {
    var normal: Normal?
    var reverseHolofoil: ReverseHolofoil?
    var holofoil: Holofoil?
}

struct Normal: Codable {
    var market: Double?
}

struct Holofoil: Codable {
    var market: Double?
}

struct ReverseHolofoil: Codable {
    var market: Double?
}
