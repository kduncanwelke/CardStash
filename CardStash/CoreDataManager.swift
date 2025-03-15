//
//  CoreDataManager.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 3/10/25.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static var shared = CoreDataManager()
    
    lazy var managedObjectContext: NSManagedObjectContext = { [unowned self] in
        var container = self.persistentContainer
        return container.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        var container = NSPersistentContainer(name: "SavedCard")
        
        container.loadPersistentStores() { storeDescription, error in
            if var error = error as NSError? {
                fatalError("unresolved error \(error), \(error.userInfo)")
            }
            
            storeDescription.shouldInferMappingModelAutomatically = true
            storeDescription.shouldMigrateStoreAutomatically = true
        }
        
        return container
    }()
}
