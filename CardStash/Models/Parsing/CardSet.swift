//
//  Set.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/19/25.
//

import Foundation

struct CardSets: SearchType {
    static var endpoint = Endpoint.cardSets
    var data: [CardSet]
}

struct CardSet: Codable {
    var id: String
    var name: String
    var series: String
    var total: Int
    var legalities: Legalities
    var releaseDate: String
    var images: SetImage
}
