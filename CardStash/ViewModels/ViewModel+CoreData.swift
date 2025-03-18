//
//  ViewModel+CoreData.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 3/10/25.
//

import Foundation
import CoreData

extension ViewModel {
    
    func changeCardQuantity(card: Card, quantity: Int) {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        if let existingSave = CachedData.owned[card.id ?? ""] {
            guard let query = card.id else { return }
            // update quantity for old save, get object to rewrite
            let fetchCard: NSFetchRequest<SavedCard> = SavedCard.fetchRequest()
            fetchCard.predicate = NSPredicate(format: "id == %@", query)
            
            guard let result = try? managedContext.fetch(fetchCard).first else { return }
            
            if quantity == 0 {
                // delete if quantity changed to 0
                managedContext.delete(result)
                CachedData.owned.removeValue(forKey: query)
            } else {
                // update quantity
                result.quantity = Int16(quantity)
                CachedData.owned[query] = quantity
            }
        } else {
            let newCardSave = SavedCard(context: managedContext)
            
            guard let identifier = card.id else { return }
            
            newCardSave.id = identifier
            newCardSave.quantity = Int16(quantity)
            CachedData.owned[identifier] = quantity
        }
        
        do {
            try managedContext.save()
            print("saved")
        } catch {
            // error
        }
    }
    
    func loadCards() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<SavedCard>(entityName: "SavedCard")

        do {
            let loaded = try managedContext.fetch(fetchRequest)
            print("cards loaded")
            
            // put loaded cards in cache
            for card in loaded {
                if let identifier = card.id {
                    CachedData.owned[identifier] = Int(card.quantity)
                }
            }
        } catch let error as NSError {
            // error
        }
    }
    
    func addFave(card: Card) {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        let newFave = FaveCard(context: managedContext)
        
        guard let identifier = card.id else { return }
        newFave.id = identifier
        CachedData.faved[identifier] = "fave"
     
        do {
            try managedContext.save()
            print("saved")
        } catch {
            // error
        }
    }
    
    func deleteFave(card: Card) {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        guard let query = card.id else { return }
        // update quantity for old save, get object to rewrite
        let fetchCard: NSFetchRequest<FaveCard> = FaveCard.fetchRequest()
        fetchCard.predicate = NSPredicate(format: "id == %@", query)
        
        guard let result = try? managedContext.fetch(fetchCard).first else { return }
        
        print("deleted fave")
        managedContext.delete(result)
        CachedData.faved.removeValue(forKey: query)
    }
    
    func loadFaves() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<FaveCard>(entityName: "FaveCard")

        do {
            let loaded = try managedContext.fetch(fetchRequest)
            print("faves loaded")
            
            // put loaded cards in cache
            for card in loaded {
                if let identifier = card.id {
                    CachedData.faved[identifier] = "fave"
                }
            }
        } catch let error as NSError {
            // error
        }
    }
}
