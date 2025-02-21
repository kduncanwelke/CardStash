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
    
    func getInitialCards() {
        SearchParameters.cardSet = "base"
        SearchParameters.name = "charizard"
        
        createSearchTerms()
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
        // TODO: remove
        SearchParameters.cardSet = ""
        
        createSearchTerms()
    }
    
    func setSorting(kind: Sorting) {
        // TODO: Apply sorting on existing cards without new query
        switch kind {
        case .auto:
            // auto
            SearchParameters.sorting = ""
        case .cardSetAZ:
            // card set ascending
            SearchParameters.sorting = "set.name"
        case .cardSetZA:
            // card set descending
            SearchParameters.sorting = "-set.name"
        case .hpLowHigh:
            // HP ascending
            SearchParameters.sorting = "hp"
        case .hpHighLow:
            // HP descending
            SearchParameters.sorting = "-hp"
        case .nameAZ:
            // name ascending
            SearchParameters.sorting = "name"
        case .nameZA:
            // name descending
            SearchParameters.sorting = "-name"
        case .numberLowHigh:
            // number ascending
            SearchParameters.sorting = "nationalPokedexNumbers"
        case .numberHighLow:
            // number descending
            SearchParameters.sorting = "-nationalPokedexNumbers"
        }
    }
    
    func setFilters() {

    }
    
    func addSearchTerms(base: String) -> String {
        var compiled = base
        
        if SearchParameters.cardSet != "" {
            compiled += " set.name:\(SearchParameters.cardSet)"
        }
        
        if SearchParameters.type != "" {
            compiled += " types:\(SearchParameters.type)"
        }
        
        if SearchParameters.weakness != "" {
            compiled += " weaknesses.type:\(SearchParameters.weakness)"
        }
        
        if SearchParameters.resistance != "" {
            compiled += " resistances.type:\(SearchParameters.resistance)"
        }
        
        if SearchParameters.retreatCost != -1 {
            compiled += " convertedRetreatCost:\(SearchParameters.retreatCost)"
        }
        
        // legality
        // holo
        
        if SearchParameters.stage != "" {
            compiled += " subtypes:\(SearchParameters.stage)"
        }
        
        if SearchParameters.rarity != "" {
            compiled += " rarity:\(SearchParameters.rarity)"
        }
        
        if SearchParameters.ability != "" {
            compiled += " abilities.name:\(SearchParameters.ability)"
        }
        
        if SearchParameters.move != "" {
            compiled += " attacks.name:\(SearchParameters.move)"
        }
        
        return compiled
    }
    
    func createSearchTerms() {
        if SearchParameters.name != "" {
            var base = "name:\(SearchParameters.name)"
            
            var compiledSearch = addSearchTerms(base: base)
            SearchParameters.searchTerms = compiledSearch
            print("search terms")
            print(compiledSearch)
        } else if SearchParameters.pokedexNumber != 0 {
            var base = "\(SearchParameters.pokedexNumber)"
            
            var compiledSearch = addSearchTerms(base: base)
            SearchParameters.searchTerms = compiledSearch
            print("search terms")
            print(compiledSearch)
        } else {
            var compiledSearch = addSearchTerms(base: "")
            // filters only, no search terms so drop first space character
            var new = compiledSearch.dropFirst(1)
            SearchParameters.searchTerms = String(new)
            print("search terms")
            print(compiledSearch)
        }
    }
}
