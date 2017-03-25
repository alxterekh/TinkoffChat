//
//  DataController.swift
//  TinkoffChat
//
//  Created by Alexander on 25/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit
import CoreData

class DataController: NSObject {
    static let sharedInstance = DataController()
    var managedObjectContext: NSManagedObjectContext?
    
    override init()
    {
        super.init()
        setup()
    }
    
    func setup()
    {
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let storeCoordinator = createStoreCoordinator()
        managedObjectContext!.persistentStoreCoordinator = storeCoordinator
        setupStoreForStoreCoordinator(coordinator: storeCoordinator)
    }
    
    func createStoreCoordinator() -> NSPersistentStoreCoordinator
    {
        guard let modelURL = Bundle.main.url(forResource:"Model",
                                             withExtension:"momd") else
        {
            fatalError("Error loading model from bundle")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else
        {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        return NSPersistentStoreCoordinator(managedObjectModel: mom)
    }
    
    func setupStoreForStoreCoordinator(coordinator: NSPersistentStoreCoordinator)
    {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        let storeURL = docURL.appendingPathComponent("Model.sqlite")
        print(storeURL)
        do
        {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: storeURL,
                                               options: nil)
        }
        catch
        {
            fatalError("Error migrating store: \(error)")
        }
    }
}
