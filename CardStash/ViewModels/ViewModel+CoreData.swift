//
//  ViewModel+CoreData.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 3/10/25.
//

import Foundation
import CoreData

extension ViewModel {
    
    func addCardToCollection(card: Card, quantity: Int) {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        let newCardSave = SavedCard(context: managedContext)
        
        newCardSave.id = card.id
        newCardSave.quantity = Int16(quantity)
        
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
        
        newFave.id = card.id
     
        do {
            try managedContext.save()
            print("saved")
        } catch {
            // error
        }
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
                    CachedData.faved.append(identifier)
                }
            }
        } catch let error as NSError {
            // error
        }
    }
}
