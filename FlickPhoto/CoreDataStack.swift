//
//  CoreDataStack.swift
//  FlickPhoto
//
//  Created by Tyler Jasper on 8/12/16.
//  Copyright © 2016 Tyler Jasper. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    let managedObjectModelName: String
    
    lazy var mainQueueContext: NSManagedObjectContext = {
        let object = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        object.persistentStoreCoordinator = self.persistentStoreCoordinator
        object.name = "Main queue context (UI Context)"
        return object
    }()
    
    lazy var backgroundQueueContext: NSManagedObjectContext = {
       let objectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        objectContext.parent = self.mainQueueContext
        objectContext.name = "Background Queue Context"
        return objectContext
    }()
    
    private var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.first! 
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        var coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let pathComponent = "\(self.managedObjectModelName).sqlite"
        let url = self.applicationDocumentsDirectory.appendingPathComponent(pathComponent)
        let store = try! coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        return coordinator
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.managedObjectModelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    required init(modelName: String) {
        managedObjectModelName = modelName
    }
    
    func saveChanges() throws {
        var error: Error?
        
        backgroundQueueContext.performAndWait() {
            if self.backgroundQueueContext.hasChanges {
                do {
                    try self.backgroundQueueContext.save()
                } catch let saveError {
                    error = saveError
                }
            }
        }
        
        if let error = error {
            throw error
        }
        
        mainQueueContext.performAndWait() {
            if self.mainQueueContext.hasChanges {
                do {
                    try self.mainQueueContext.save()
                } catch let saveError {
                    error = saveError
                }
            }
        }
        if let error = error {
            throw error
        }
    }
}
