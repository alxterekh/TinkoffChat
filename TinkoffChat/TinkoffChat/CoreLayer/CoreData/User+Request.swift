//
//  User+Request.swift
//  TinkoffChat
//
//  Created by Alexander on 13/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import CoreData

extension User {
    static func fetchRequestUser(model: NSManagedObjectModel, identifier: String) -> NSFetchRequest<User>? {
        let templateName = "UserWithId"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["identifier" : identifier]) as? NSFetchRequest<User> else {
            assert(false, "No template with name \(templateName)")
            
            return nil
        }
        
        return fetchRequest
    }
    
    static func findOrInsertUser(in context: NSManagedObjectContext, with identidier: String) -> User? {
        var user: User?
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("No managed object model in context!")
            assert(false)
            
            return nil
        }
        
        guard let fetchRequest = User.fetchRequestUser(model: model, identifier: identidier) else {
            
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            if let foundUser = results.first {
                user = foundUser
            }
        }
        catch {
            print("Failed to fetch User with Id")
        }
        
        if user == nil {
            user = User(context: context)
            user?.userId = identidier
        }
        
        return user
    }
}
