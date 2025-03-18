//
//  ViewModel.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/19/25.
//

import Foundation
import UIKit

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
        createSearchTerms()
        SearchParameters.cardSet = ""
    }
    
    func getCardSource() -> [Card] {
        if SearchParameters.isNewSearch {
            return CachedData.cards
        } else {
            return CachedData.sorted
        }
    }
    
    func getCardCount() -> Int {
        let cards = getCardSource()
        return cards.count
    }
    
    func showHideHeart(index: Int) -> Bool {
        let cards = getCardSource()
        if let fave = CachedData.faved[cards[index].id ?? ""] {
            return false
        } else {
            return true
        }
    }
    
    func getCardName(index: Int) -> String {
        let cards = getCardSource()
        return cards[index].name ?? "Unknown"
    }
    
    func getCardNumber(index: Int) -> String {
        let cards = getCardSource()
        if let number = cards[index].nationalPokedexNumbers?.first {
            return "#\(number)"
        } else {
            return "Unknown"
        }
    }
    
    func getCardHP(index: Int) -> String {
        let cards = getCardSource()
        
        if let hitPoints = cards[index].hp {
            return "\(hitPoints)HP"
        } else {
            // trainers and energy do not have HP so show nothing
            return " "
        }
    }
    
    func getCardSet(index: Int) -> String {
        let cards = getCardSource()
        return cards[index].set?.name ?? "Unknown"
    }
    
    func getCardType(index: Int) -> String {
        let cards = getCardSource()
        return cards[index].types?.first ?? "Unknown"
    }
    
    func getCardStage(index: Int) -> String {
        let cards = getCardSource()
        return cards[index].subtypes?.first ?? "Unknown"
    }
    
    func getCardWeakness(index: Int) -> String {
        let cards = getCardSource()
        return cards[index].weaknesses?.first?.type ?? "None"
    }
    
    func getCardResistance(index: Int) -> String {
        let cards = getCardSource()
        return cards[index].resistances?.first?.type ?? "None"
    }
    
    func getCardRetreatCost(index: Int) -> String {
        let cards = getCardSource()
        if let retreat = cards[index].convertedRetreatCost {
            return "\(retreat)"
        } else {
            return "None"
        }
    }
    
    func getCardFlavorText(index: Int) -> String {
        let cards = getCardSource()
        return cards[index].flavorText ?? "Unknown"
    }
    
    func getImageURL(index: Int) -> URL? {
        let cards = getCardSource()
       
        if let url = cards[index].images?.large {
            return URL(string: url)
        } else {
            return nil
        }
    }
    
    func getHeartForCard(index: Int) -> UIImage? {
        let cards = getCardSource()
        let current = CachedData.selected
        if let faved = CachedData.faved[cards[current].id ?? ""] {
            // it's a favorite
            return UIImage(systemName: "heart.fill")
        } else {
            return UIImage(systemName: "heart")
        }
    }
    
    func getHeartTitle(index: Int) -> String {
        let cards = getCardSource()
        let current = CachedData.selected
        if let faved = CachedData.faved[cards[current].id ?? ""] {
            // it's a favorite
            return "Favorited"
        } else {
            return "Favorite?"
        }
    }
    
    func setIndexPath(index: IndexPath) {
        CachedData.indexPath = index
    }
    
    func getIndexPath() -> IndexPath? {
        return CachedData.indexPath
    }
    
    func setSelected(index: Int) {
        CachedData.selected = index
    }
    
    func getSelected() -> Int {
        return CachedData.selected
    }
    
    func isFavorite() {
        let source = getCardSource()
        let current = CachedData.selected
        if let faved = CachedData.faved[source[current].id ?? ""] {
            // if a favorite, unfavorite it
            deleteFave(card: source[current])
        } else {
            print("faved \(source[current].id)")
            addFave(card: source[current])
        }
    }
    
    func showOwned(index: Int) -> Bool {
        let source = getCardSource()
        if let owned = CachedData.owned[source[index].id ?? ""] {
            return false
        } else {
            return true
        }
    }
    
    func getOwnedQuantity(index: Int) -> String {
        let source = getCardSource()
        if let owned = CachedData.owned[source[index].id ?? ""] {
            return "\(owned)"
        } else {
            return "\(0)"
        }
    }
    
    func increaseOwned() {
        var newQuantity: Int

        let source = getCardSource()
        let current = CachedData.selected
        if let owned = CachedData.owned[source[current].id ?? ""] {
            // already owned
            newQuantity = owned + 1
        } else {
            newQuantity = 1
        }
        
        changeCardQuantity(card: source[current], quantity: newQuantity)
    }
    
    func decreaseOwned() {
        var newQuantity: Int

        let source = getCardSource()
        let current = CachedData.selected
        if let owned = CachedData.owned[source[current].id ?? ""] {
            // already owned
            if owned > 0 {
                newQuantity = owned - 1
                changeCardQuantity(card: source[current], quantity: newQuantity)
            } else {
                newQuantity = 0
            }
        } else {
            newQuantity = 0
        }
    }
    
    // MARK: Data manipulation
    
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
    
    func setTypeFilter(kind: PokemonType) {
        switch kind {
        case .any:
            SearchParameters.type = ""
        case .colorless:
            SearchParameters.type = "colorless"
        case .fire:
            SearchParameters.type = "fire"
        case .lightning:
            SearchParameters.type = "lightning"
        case .grass:
            SearchParameters.type = "grass"
        case .water:
            SearchParameters.type = "water"
        case .psychic:
            SearchParameters.type = "psychic"
        case .darkness:
            SearchParameters.type = "darkness"
        case .fairy:
            SearchParameters.type = "fairy"
        case .dragon:
            SearchParameters.type = "dragon"
        case .metal:
            SearchParameters.type = "metal"
        case .fighting:
            SearchParameters.type = "fighting"
        }
    }
    
    func setWeaknessFilter(kind: PokemonType) {
        switch kind {
        case .any:
            SearchParameters.weakness = ""
        case .colorless:
            SearchParameters.weakness = "colorless"
        case .fire:
            SearchParameters.weakness = "fire"
        case .lightning:
            SearchParameters.weakness = "lightning"
        case .grass:
            SearchParameters.weakness = "grass"
        case .water:
            SearchParameters.weakness = "water"
        case .psychic:
            SearchParameters.weakness = "psychic"
        case .darkness:
            SearchParameters.weakness = "darkness"
        case .fairy:
            SearchParameters.weakness = "fairy"
        case .dragon:
            SearchParameters.weakness = "dragon"
        case .metal:
            SearchParameters.weakness = "metal"
        case .fighting:
            SearchParameters.weakness = "fighting"
        }
    }
    
    func setResistanceFilter(kind: PokemonType) {
        switch kind {
        case .any:
            SearchParameters.resistance = ""
        case .colorless:
            SearchParameters.resistance = "colorless"
        case .fire:
            SearchParameters.resistance = "fire"
        case .lightning:
            SearchParameters.resistance = "lightning"
        case .grass:
            SearchParameters.resistance = "grass"
        case .water:
            SearchParameters.resistance = "water"
        case .psychic:
            SearchParameters.resistance = "psychic"
        case .darkness:
            SearchParameters.resistance = "darkness"
        case .fairy:
            SearchParameters.resistance = "fairy"
        case .dragon:
            SearchParameters.resistance = "dragon"
        case .metal:
            SearchParameters.resistance = "metal"
        case .fighting:
            SearchParameters.resistance = "fighting"
        }
    }
    
    func setStageFilter(kind: PokemonStage) {
        switch kind {
        case .any:
            SearchParameters.stage = ""
        case .baby:
            SearchParameters.stage = "baby"
        case .basic:
            SearchParameters.stage = "basic"
        case .stage1:
            SearchParameters.stage = "\"Stage 1\""
        case.stage2:
            SearchParameters.stage = "\"Stage 2\""
        }
    }
    
    func setCardTypeFilter(kind: CardType) {
        switch kind {
        case .any:
            SearchParameters.superType = ""
        case .pokemon:
            SearchParameters.superType = "pokemon"
        case .energy:
            SearchParameters.superType = "energy"
        case .trainer:
            SearchParameters.superType = "trainer"
        }
    }
    
    func setHoloFilter(kind: HoloType) {
        switch kind {
        case .any:
            SearchParameters.holo = ""
        case .holo:
            SearchParameters.holo = "holo"
        case .notHolo:
            SearchParameters.holo = "not"
        }
    }
    
    func setRarityFilter(kind: Rarity) {
        switch kind {
        case .any:
            SearchParameters.rarity = ""
        case .common:
            SearchParameters.rarity = "common"
        case .uncommon:
            SearchParameters.rarity = "uncommon"
        case .rare:
            SearchParameters.rarity = "rare"
        case .promo:
            SearchParameters.rarity = "promo"
        case .legend:
            SearchParameters.rarity = "LEGEND"
        }
    }
    
    func setLegalityFilter(kind: Legality) {
        switch kind {
        case .any:
            SearchParameters.legality = ""
        case .standard:
            SearchParameters.legality = ".standard:legal"
        case .expanded:
            SearchParameters.legality = ".expanded:legal"
        case .unlimited:
            SearchParameters.legality = ".unlimited:legal"
        }
    }
    
    func setRetreatCostFilter(amount: Int) {
        SearchParameters.retreatCost = amount
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
        
        if SearchParameters.legality != "" {
            compiled += " legalities\(SearchParameters.legality)"
        }
        
        if SearchParameters.holo != "" {
            if SearchParameters.holo == "holo" {
                // holographic
                compiled += " rarity:\(SearchParameters.holo)"
            } else {
                // non holographic
                compiled += " -rarity:\(SearchParameters.holo)"
            }
        }
        
        if SearchParameters.superType != "" {
            compiled += " supertype:\(SearchParameters.superType)"
        }
        
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
