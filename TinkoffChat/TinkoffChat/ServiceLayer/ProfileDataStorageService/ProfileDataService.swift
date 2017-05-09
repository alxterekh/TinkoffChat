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

class ProfileDataService : ProfileDataStorage {
    
    fileprivate let coreDataStack: CoreDataStackContextProvider
    
    // MARK: -
    
    init(with coreDataStack: CoreDataStackContextProvider) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: -
    
    func loadProfileData(completion: @escaping (Profile?, Error?) -> Void) {
        var profile: Profile?
        if let context = coreDataStack.mainContext {
            if let user = findOrInsertUser(in: context) {
                if let userPicture = user.userPicture {
                    let avatar = UIImage(data: userPicture as Data)
                    profile = Profile.createDefaultProfile()
                    profile = profile?.createCopyWithChange(name: user.name, userInfo: user.userInfo, userPicture: avatar)
                }
            }
        }
        
        completion(profile, nil)
    }
    
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void) {
        if let context = coreDataStack.saveContext {
            if let user = findOrInsertUser(in: context) {
                user.name = profile.name
                user.userInfo = profile.userInfo
                user.userPicture = UIImageJPEGRepresentation(profile.userPicture, 1.0) as NSData?
            }
            
            performSave(context: context, completionHandler: completion)
        }
    }
    
    // MARK: -

    fileprivate func findOrInsertUser(in context: NSManagedObjectContext) -> User? {
        var user: User?
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
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
           // User(context: context)
    }

    fileprivate func performSave(context: NSManagedObjectContext, completionHandler: @escaping (Bool, Error?) -> Void) {
        if context.hasChanges {
            context.perform {
                [weak self] in
                
                do {
                    try context.save()
                }
                catch {
                    DispatchQueue.main.async { completionHandler(false, error) }
                    print("Context save error: \(error)")
                }
                
                if let parent = context.parent {
                    self?.performSave(context: parent, completionHandler: completionHandler)
                }
                else {
                    DispatchQueue.main.async { completionHandler(true, nil) }
                }
            }
        }
        else {
            completionHandler(true, nil)
        }
    }
}

