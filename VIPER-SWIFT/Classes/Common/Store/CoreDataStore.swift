//
//  CoreDataStore.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/4/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStore: NSObject {

    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let model = NSManagedObjectModel.mergedModelFromBundles(nil) else { fatalError() }
        return model
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let psc = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let documentsDirectory = NSFileManager.defaultManager().documentsDirectory()
        let storeURL = documentsDirectory.URLByAppendingPathComponent("VIPER-SWIFT.sqlite")
        let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                       NSInferMappingModelAutomaticallyOption: true]
        do {
            try psc.addPersistentStoreWithType(NSSQLiteStoreType,
                                               configuration: "",
                                               URL: storeURL,
                                               options: options)
        } catch {
            fatalError()
        }

        return psc
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.undoManager = nil
        return context
    }()

    func fetchEntriesWithPredicate(predicate: NSPredicate,
                                   sortDescriptors: [NSSortDescriptor],
                                   completionBlock: (([ManagedTodoItem]) -> Void)!) {
        let fetchRequest = NSFetchRequest(entityName: "TodoItem")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors

        managedObjectContext.performBlock {
            guard let results = try? self.managedObjectContext.executeFetchRequest(fetchRequest),
                let todoResults = results as? [ManagedTodoItem] else {
                    completionBlock([])
                    return
            }
            completionBlock(todoResults)
        }
    }

    func newTodoItem() -> ManagedTodoItem {
        guard let newEntry = NSEntityDescription.insertNewObjectForEntityForName(
            "TodoItem",
            inManagedObjectContext: managedObjectContext) as? ManagedTodoItem else {
                fatalError()
        }

        return newEntry
    }

    func save() {
        do {
            try managedObjectContext.save()
        } catch {}
    }
}

extension NSFileManager {
    func documentsDirectory() -> NSURL {
        let domains = NSSearchPathDomainMask.UserDomainMask
        let directory = NSSearchPathDirectory.DocumentDirectory
        guard let url = URLsForDirectory(directory, inDomains: domains).first
            else { fatalError() }
        return url
    }
}
