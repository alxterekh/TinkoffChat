//
//  ProfileDataService.swift
//  TinkoffChat
//
//  Created by Alexander on 17/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit
import CoreData

protocol ProfileDataStorage {
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void)
    func loadProfileData(completion: @escaping (Profile?, Error?) -> Void)
}

extension User {
    static func fetchRequestUser(model: NSManagedObjectModel) -> NSFetchRequest<User>? {
        let templateName = "User"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<User> else {
            assert(false, "No template with name \(templateName)")
            
            return nil
        }
        
        return fetchRequest
    }
}

class ProfileDataService : ProfileDataStorage {
    
    let coreDataStack = CoreDataStack()
    
    func loadProfileData(completion: @escaping (Profile?, Error?) -> Void) {
        var profile: Profile?
        if let user = findOrInsertUser(in: coreDataStack.mainContext!) {
            if let _ = user.name {
                 profile = Profile(name: user.name!, userInfo: "", userPicture: #imageLiteral(resourceName: "placeholder"))
            }
    
        }
       
        completion(profile, nil)
    }
    
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void) {
        if let user = findOrInsertUser(in: coreDataStack.saveContext!) {
            user.name = profile.name
            user.userInfo = profile.userInfo
        }
        
        performSave(context: coreDataStack.saveContext!, completionHandler: completion)
    }

    fileprivate func findOrInsertUser(in context: NSManagedObjectContext) -> User? {
        var user: User?
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("No managed object model in context!")
            assert(false)
            
            return nil
        }
        
        guard let fetchRequest = User.fetchRequestUser(model: model) else {
            
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            if let foundUser = results.first {
                user = foundUser
            }
        }
        catch {
            print("Failed to fetch Profile")
        }
        
        if user == nil {
            user = insertUser(in: context)
        }
        
        return user
    }
    
    fileprivate func insertUser(in context: NSManagedObjectContext) -> User? {
        return NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User
    }

    fileprivate func performSave(context: NSManagedObjectContext, completionHandler: @escaping (Bool, Error?) -> Void) {
        if context.hasChanges {
            context.perform {
                [weak self] in
                
                do {
                    try context.save()
                }
                catch {
                    completionHandler(false, error)
                    print("Context save error: \(error)")
                }
                if let parent = context.parent {
                    self?.performSave(context: parent, completionHandler: completionHandler)
                }
                else {
                    completionHandler(true, nil)
                }
            }
        }
        else {
            completionHandler(true, nil)
        }
    }
}

