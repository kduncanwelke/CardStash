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
                // wipe cache
                CachedData.cards = []
                
                if let data = response.first {
                    var foundCards: [Card] = []
                    
                    for card in data.data {
                        foundCards.append(card)
                        print(card)
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
    
    func getCardName(index: Int) -> String {
        return CachedData.cards[index].name ?? "Unknown"
    }
    
    func getCardHP(index: Int) -> String {
        return "\(CachedData.cards[index].hp ?? "-")HP"
    }
    
    func getCardSet(index: Int) -> String {
        return CachedData.cards[index].set?.name ?? "Unknown"
    }
    
    func getImageURL(index: Int) -> URL? {
        if let url = CachedData.cards[index].images?.large {
            return URL(string: url)
        } else {
            return nil
        }
    }
    
    func setSearch(search: String) {
        if let pokedexNumber = Int(search) {
            SearchParameters.pokedexNumber = pokedexNumber
            SearchParameters.name = ""
        } else {
            SearchParameters.name = search
            SearchParameters.pokedexNumber = 0
        }
        
        createSearchTerms()
    }
    
    func setSorting(kind: Int) {
        switch kind {
        case 0:
            // auto
            SearchParameters.sorting = ""
        case 1:
            // card set ascending
            SearchParameters.sorting = "?orderBy:set"
        case 2:
            // card set descending
            SearchParameters.sorting = "?orderBy:-set"
        case 3:
            // HP ascending
            SearchParameters.sorting = "?orderBy:hp"
        case 4:
            // HP descending
            SearchParameters.sorting = "?orderBy:-hp"
        case 5:
            // name ascending
            SearchParameters.sorting = "?orderBy:name"
        case 6:
            // name descending
            SearchParameters.sorting = "?orderBy:-name"
        case 7:
            // number ascending
            SearchParameters.sorting = "?orderBy:nationalPokedexNumbers"
        case 8:
            // number descending
            SearchParameters.sorting = "?orderBy:-nationalPokedexNumbers"
        default:
            break
        }
    }
    
    func createSearchTerms() {
        if SearchParameters.name != "" {
            if SearchParameters.sorting == "" {
                SearchParameters.searchTerms = "name:\(SearchParameters.name)"
            } else {
                SearchParameters.searchTerms = "name:\(SearchParameters.name)\(SearchParameters.sorting)"
            }
        } else if SearchParameters.pokedexNumber != 0 {
            if SearchParameters.sorting == "" {
                SearchParameters.searchTerms = "nationalPokedexNumbers:\(SearchParameters.pokedexNumber)"
            } else {
                SearchParameters.searchTerms = "nationalPokedexNumbers:\(SearchParameters.pokedexNumber)\(SearchParameters.sorting)"
            }
        }
    }
}
