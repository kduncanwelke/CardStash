//
//  ViewModel.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/19/25.
//

import Foundation
import UIKit

public class ViewModel {
    
    // MARK: Card Sets
    
    func getCardSets(completion: @escaping () -> Void) {
        DataManager<CardSets>.fetch() { result in
            switch result {
            case .success(let response):
                // wipe cache
                CachedData.cardSets = []
                
                if let data = response.first {
                    var foundCardSets: [CardSet] = []
                    
                    for cardSet in data.data {
                        foundCardSets.append(cardSet)
                        print(cardSet)
                    }
                    
                    CachedData.cardSets = foundCardSets
                    CachedData.cardSets.insert(CardSet(name: "Any"), at: 0)
                }
                
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    func getCardSetCount() -> Int {
        return CachedData.cardSets.count
    }
    
    func getCardSetTitle(index: Int) -> String {
        return CachedData.cardSets[index].name ?? ""
    }
    
    func setSelectedCardSet(index: Int) {
        SearchParameters.cardSet = CachedData.cardSets[index].name ?? ""
    }
    
    // MARK: Cards
    
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
    
    func getOwnedCards(completion: @escaping () -> Void) {
        DataManager<Cards>.fetch() { result in
            switch result {
            case .success(let response):
                // wipe cache
                CachedData.ownedCards = []
                
                if let data = response.first {
                    var foundCards: [Card] = []
                    
                    for card in data.data {
                        foundCards.append(card)
                        print(card)
                    }
                    
                    CachedData.ownedCards = foundCards
                }
               
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    func getFaveCards(completion: @escaping () -> Void) {
        DataManager<Cards>.fetch() { result in
            switch result {
            case .success(let response):
                // wipe cache
                CachedData.faveCards = []
                
                if let data = response.first {
                    var foundCards: [Card] = []
                    
                    for card in data.data {
                        foundCards.append(card)
                        print(card)
                    }
                    
                    CachedData.faveCards = foundCards
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
    
    func switchTo(source: SelectedCards, completion: @escaping () -> Void) {
        switch source {
        case .all:
            CachedData.currentCardType = .all
            
            if CachedData.cards.isEmpty {
                getInitialCards()
            }
            
            if SearchParameters.sortingKind != .auto {
                CachedData.currentCardType = .allSorted
            }
        case .allSorted:
            CachedData.currentCardType = .allSorted
            
            if SearchParameters.sortingKind == .auto {
                CachedData.currentCardType = .all
            }
        case .owned:
            CachedData.currentCardType = .owned
            
            if !(CachedData.owned.isEmpty) && CachedData.ownedCards.isEmpty {
                createSavedSearchTerms()
                getOwnedCards {
                    completion()
                }
            }
            
            if SearchParameters.sortingKind != .auto {
                CachedData.currentCardType = .ownedSorted
            }
        case .ownedSorted:
            CachedData.currentCardType = .ownedSorted
            
            if SearchParameters.sortingKind == .auto {
                CachedData.currentCardType = .owned
            }
        case .faves:
            CachedData.currentCardType = .faves
            
            if !(CachedData.faved.isEmpty) && CachedData.faveCards.isEmpty {
                createSavedSearchTerms()
                getFaveCards {
                    completion()
                }
            }
            
            if SearchParameters.sortingKind != .auto {
                CachedData.currentCardType = .favesSorted
            }
        case .favesSorted:
            CachedData.currentCardType = .favesSorted
            
            if SearchParameters.sortingKind == .auto {
                CachedData.currentCardType = .faves
            }
        }
        
        completion()
    }
    
    func getCardType() -> SelectedCards {
        return CachedData.currentCardType
    }
    
    func getCardSource() -> [Card] {
        switch CachedData.currentCardType {
        case .all:
            return CachedData.cards
        case .allSorted:
            return CachedData.sorted
        case .owned:
            return CachedData.ownedCards
        case .ownedSorted:
            return CachedData.sortedOwned
        case .faves:
            return CachedData.faveCards
        case .favesSorted:
            return CachedData.sortedFaves
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
    
    func getCardRarity(index: Int) -> String {
        let cards = getCardSource()
        
        if let rarity = cards[index].rarity {
            return rarity
        } else {
            return "Unknown"
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
    
    func getOwnedNumber(index: Int) -> Int {
        let source = getCardSource()
        if let owned = CachedData.owned[source[index].id ?? ""] {
            return owned
        } else {
            return 0
        }
    }
    
    // MARK: Data manipulation
    
    func changeOwned(quantity: Int) {
        let source = getCardSource()
        let current = CachedData.selected
        
        changeCardQuantity(card: source[current], quantity: quantity)
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
    
    func decreaseOwnedWithDelete() -> Bool {
        var newQuantity: Int

        let source = getCardSource()
        let current = CachedData.selected
        if let owned = CachedData.owned[source[current].id ?? ""] {
            // already owned
            if owned > 0 {
                newQuantity = owned - 1
                changeCardQuantity(card: source[current], quantity: newQuantity)
                if newQuantity == 0 {
                    return true
                } else {
                    return false
                }
            } else {
                newQuantity = 0
                return false
            }
        } else {
            newQuantity = 0
            return false
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
        
        if CachedData.currentCardType == .all {
            createSearchTerms()
        }

        completion()
    }
    
    func setSorting(kind: Sorting, completion: @escaping () -> Void) {
        print("cards selected \(CachedData.currentCardType)")
        
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
        
        switch CachedData.currentCardType {
        case .all:
            createSearchTerms()
            // only set sorting for API request when performing a new search, otherwise sort cached
        case .allSorted:
            // sort
            switch SearchParameters.sortingKind {
            case .auto:
                // use cached, unsorted cards
                CachedData.sorted = CachedData.cards
            case .cardSetAZ:
                print("sort A-Z")
                CachedData.sorted = CachedData.cards.sorted { cardA, cardB in
                    cardA.set?.name ?? "" < cardB.set?.name ?? ""
                }
                
            case .cardSetZA:
                CachedData.sorted = CachedData.cards.sorted { cardA, cardB in
                    cardA.set?.name ?? "" > cardB.set?.name ?? ""
                }
            case .hpLowHigh:
                CachedData.sorted = CachedData.cards.sorted { cardA, cardB in
                    Int(cardA.hp ?? "0") ?? 0 < Int(cardB.hp ?? "0") ?? 0
                }
            case .hpHighLow:
                CachedData.sorted = CachedData.cards.sorted { cardA, cardB in
                    Int(cardA.hp ?? "0") ?? 0 > Int(cardB.hp ?? "0") ?? 0
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
        case .ownedSorted, .owned:
            switch SearchParameters.sortingKind {
            case .auto:
                // use cached, unsorted cards
                CachedData.sortedOwned = CachedData.ownedCards
            case .cardSetAZ:
                CachedData.sortedOwned = CachedData.ownedCards.sorted { cardA, cardB in
                    cardA.set?.name ?? "" < cardB.set?.name ?? ""
                }
            case .cardSetZA:
                CachedData.sortedOwned = CachedData.ownedCards.sorted { cardA, cardB in
                    cardA.set?.name ?? "" > cardB.set?.name ?? ""
                }
            case .hpLowHigh:
                CachedData.sortedOwned = CachedData.ownedCards.sorted { cardA, cardB in
                    Int(cardA.hp ?? "0") ?? 0 < Int(cardB.hp ?? "0") ?? 0
                }
            case .hpHighLow:
                CachedData.sortedOwned = CachedData.ownedCards.sorted { cardA, cardB in
                    Int(cardA.hp ?? "0") ?? 0 > Int(cardB.hp ?? "0") ?? 0
                }
            case .nameAZ:
                CachedData.sortedOwned = CachedData.ownedCards.sorted { cardA, cardB in
                    cardA.name ?? "" < cardB.name ?? ""
                }
            case .nameZA:
                CachedData.sortedOwned = CachedData.ownedCards.sorted { cardA, cardB in
                    cardA.name ?? "" > cardB.name ?? ""
                }
            case .numberLowHigh:
                CachedData.sortedOwned = CachedData.ownedCards.sorted { cardA, cardB in
                    cardA.nationalPokedexNumbers?.first ?? 0 < cardB.nationalPokedexNumbers?.first ?? 0
                }
            case .numberHighLow:
                CachedData.sortedOwned = CachedData.ownedCards.sorted { cardA, cardB in
                    cardA.nationalPokedexNumbers?.first ?? 0 > cardB.nationalPokedexNumbers?.first ?? 0
                }
            }
        case .favesSorted, .faves:
            switch SearchParameters.sortingKind {
            case .auto:
                // use cached, unsorted cards
                CachedData.sortedFaves = CachedData.faveCards
            case .cardSetAZ:
                CachedData.sortedFaves = CachedData.faveCards.sorted { cardA, cardB in
                    cardA.set?.name ?? "" < cardB.set?.name ?? ""
                }
            case .cardSetZA:
                CachedData.sortedFaves = CachedData.faveCards.sorted { cardA, cardB in
                    cardA.set?.name ?? "" > cardB.set?.name ?? ""
                }
            case .hpLowHigh:
                CachedData.sortedFaves = CachedData.faveCards.sorted { cardA, cardB in
                    cardA.hp ?? "" < cardB.hp ?? ""
                }
            case .hpHighLow:
                CachedData.sortedFaves = CachedData.faveCards.sorted { cardA, cardB in
                    Int(cardA.hp ?? "0") ?? 0 > Int(cardB.hp ?? "0") ?? 0
                }
            case .nameAZ:
                CachedData.sortedFaves = CachedData.faveCards.sorted { cardA, cardB in
                    cardA.name ?? "" < cardB.name ?? ""
                }
            case .nameZA:
                CachedData.sortedFaves = CachedData.faveCards.sorted { cardA, cardB in
                    cardA.name ?? "" > cardB.name ?? ""
                }
            case .numberLowHigh:
                CachedData.sortedFaves = CachedData.faveCards.sorted { cardA, cardB in
                    cardA.nationalPokedexNumbers?.first ?? 0 < cardB.nationalPokedexNumbers?.first ?? 0
                }
            case .numberHighLow:
                CachedData.sortedFaves = CachedData.faveCards.sorted { cardA, cardB in
                    cardA.nationalPokedexNumbers?.first ?? 0 > cardB.nationalPokedexNumbers?.first ?? 0
                }
            }
        }
        completion()
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
            if SearchParameters.cardSet != "Any" {
                compiled += " set.name:\(SearchParameters.cardSet)"
            } else {
                SearchParameters.cardSet = ""
            }
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
    
    func createSavedSearchTerms() {
        switch CachedData.currentCardType {
        case .all:
            return
        case .allSorted:
            return
        case .owned:
            var base = ""
            for (id, quantity) in CachedData.owned {
                base.append("id:\(id) OR ")
            }
            // remove last OR and spaces, it breaks the query
            let searchTerms = base.dropLast(4)
            SearchParameters.searchTerms = String(searchTerms)
        case .ownedSorted:
            return
        case .faves:
            var base = ""
            for (id, quantity) in CachedData.faved {
                base.append("id:\(id) OR ")
            }
            // remove last OR and spaces, it breaks the query
            let searchTerms = base.dropLast(4)
            SearchParameters.searchTerms = String(searchTerms)
        case .favesSorted:
            return
        }
    }
}
