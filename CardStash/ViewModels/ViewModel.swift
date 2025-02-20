//
//  ViewModel.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/19/25.
//

import Foundation

public class ViewModel {
    
    func getCards(completion: @escaping () -> Void) {
        DataManager<Cards>.fetch() { result in
            switch result {
            case .success(let response):
                if let data = response.first {
                    var foundCards: [Card] = []
                    
                    for card in data.data {
                        foundCards.append(card)
                    }
                    
                    CachedData.cards = foundCards
                }
               
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    func getCardCount() -> Int {
        return CachedData.cards.count
    }
}
