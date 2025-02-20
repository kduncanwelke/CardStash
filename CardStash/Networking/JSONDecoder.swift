//
//  JSONDecoder.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/19/25.
//

import Foundation

// decoder for snakecase conversion
extension JSONDecoder {
    static var pokemonAPIDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
}
