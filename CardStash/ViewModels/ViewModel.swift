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
        // TODO: Reset card set
        createSearchTerms()
    }
    
    func getCardCount() -> Int {
        if SearchParameters.isNewSearch {
            return CachedData.cards.count
        } else {
            return CachedData.sorted.count
        }
    }
    
    func getCardName(index: Int) -> String {
        if SearchParameters.isNewSearch {
            return CachedData.cards[index].name ?? "Unknown"
        } else {
            return CachedData.sorted[index].name ?? "Unknown"
        }
    }
    
    func getCardHP(index: Int) -> String {
        if SearchParameters.isNewSearch {
            if let hitPoints = CachedData.cards[index].hp {
                return "\(hitPoints)HP"
            } else {
                // trainers and energy do not have HP so show nothing
                return " "
            }
        } else {
            if let hitPoints = CachedData.sorted[index].hp {
                return "\(hitPoints)HP"
            } else {
                // trainers and energy do not have HP so show nothing
                return " "
            }
        }
    }
    
    func getCardSet(index: Int) -> String {
        if SearchParameters.isNewSearch {
            return CachedData.cards[index].set?.name ?? "Unknown"
        } else {
            return CachedData.sorted[index].set?.name ?? "Unknown"
        }
    }
    
    func getImageURL(index: Int) -> URL? {
        if SearchParameters.isNewSearch {
            if let url = CachedData.cards[index].images?.large {
                return URL(string: url)
            } else {
                return nil
            }
        } else {
            if let url = CachedData.sorted[index].images?.large {
                return URL(string: url)
            } else {
                return nil
            }
        }
    }
    
    func setSearch(search: String, completion: @escaping () -> Void) {
        if let pokedexNumber = Int(search) {
            SearchParameters.pokedexNumber = pokedexNumber
            SearchParameters.name = ""
        } else {
            SearchParameters.name = search
            SearchParameters.pokedexNumber = 0
        }
       
        createSearchTerms()
        completion()
    }
    
    func setSorting(kind: Sorting, completion: @escaping () -> Void) {
        createSearchTerms()
        
        switch kind {
        case .auto:
            // auto
            SearchParameters.sorting = ""
            SearchParameters.sortingKind = .auto
        case .cardSetAZ:
            // card set ascending
            SearchParameters.sorting = "set.name"
            SearchParameters.sortingKind = .cardSetAZ
        case .cardSetZA:
            // card set descending
            SearchParameters.sorting = "-set.name"
            SearchParameters.sortingKind = .cardSetZA
        case .hpLowHigh:
            // HP ascending
            SearchParameters.sorting = "hp"
            SearchParameters.sortingKind = .hpLowHigh
        case .hpHighLow:
            // HP descending
            SearchParameters.sorting = "-hp"
            SearchParameters.sortingKind = .hpHighLow
        case .nameAZ:
            // name ascending
            SearchParameters.sorting = "name"
            SearchParameters.sortingKind = .nameAZ
        case .nameZA:
            // name descending
            SearchParameters.sorting = "-name"
            SearchParameters.sortingKind = .nameZA
        case .numberLowHigh:
            // number ascending
            SearchParameters.sorting = "nationalPokedexNumbers"
            SearchParameters.sortingKind = .numberLowHigh
        case .numberHighLow:
            // number descending
            SearchParameters.sorting = "-nationalPokedexNumbers"
            SearchParameters.sortingKind = .numberHighLow
        }
        
        // check if search is new, or just having new sorting applied
        if SearchParameters.isNewSearch == false {
            // sort
            switch SearchParameters.sortingKind {
            case .auto:
                // use cached, unsorted cards
                CachedData.sorted = CachedData.cards
            case .cardSetAZ:
                CachedData.sorted = CachedData.cards.sorted { cardA, cardB in
                    cardA.set?.name ?? "" < cardB.set?.name ?? ""
                }
            case .cardSetZA:
                CachedData.sorted = CachedData.cards.sorted { cardA, cardB in
                    cardA.set?.name ?? "" > cardB.set?.name ?? ""
                }
            case .hpLowHigh:
                CachedData.sorted = CachedData.cards.sorted { cardA, cardB in
                    cardA.hp ?? "" < cardB.hp ?? ""
                }
            case .hpHighLow:
                CachedData.sorted = CachedData.cards.sorted { cardA, cardB in
                    cardA.hp ?? "" > cardB.hp ?? ""
                }
            case .nameAZ:
                CachedData.sorted = CachedData.cards.sorted { cardA, cardB in
                    cardA.name ?? "" < cardB.name ?? ""
                }
            case .nameZA:
                CachedData.sorted = CachedData.cards.sorted { cardA, cardB in
                    cardA.name ?? "" > cardB.name ?? ""
                }
            case .numberLowHigh:
                CachedData.sorted = CachedData.cards.sorted { cardA, cardB in
                    cardA.nationalPokedexNumbers?.first ?? 0 < cardB.nationalPokedexNumbers?.first ?? 0
                }
            case .numberHighLow:
                CachedData.sorted = CachedData.cards.sorted { cardA, cardB in
                    cardA.nationalPokedexNumbers?.first ?? 0 > cardB.nationalPokedexNumbers?.first ?? 0
                }
            }
            completion()
        } else {
            // no sorting
            completion()
        }
    }
    
    func isNewSearch() -> Bool {
        return SearchParameters.isNewSearch
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
            SearchParameters.prevSearch = SearchParameters.searchTerms
            var base = "name:\(SearchParameters.name)"
            
            var compiledSearch = addSearchTerms(base: base)
            SearchParameters.searchTerms = compiledSearch
            print("search terms")
            print(compiledSearch)
        } else if SearchParameters.pokedexNumber != 0 {
            SearchParameters.prevSearch = SearchParameters.searchTerms
            var base = "\(SearchParameters.pokedexNumber)"
            
            var compiledSearch = addSearchTerms(base: base)
            SearchParameters.searchTerms = compiledSearch
            print("search terms")
            print(compiledSearch)
        } else {
            SearchParameters.prevSearch = SearchParameters.searchTerms
            var compiledSearch = addSearchTerms(base: "")
            // filters only, no search terms so drop first space character
            var new = compiledSearch.dropFirst(1)
            SearchParameters.searchTerms = String(new)
            print("search terms")
            print(compiledSearch)
        }
        
        if SearchParameters.searchTerms == SearchParameters.prevSearch {
            SearchParameters.isNewSearch = false
        } else {
            SearchParameters.isNewSearch = true
        }
    }
}
