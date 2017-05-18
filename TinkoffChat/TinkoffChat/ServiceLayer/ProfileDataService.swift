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
    fileprivate let appUserId = "appUserId"
    fileprivate let coreDataStack: CoreDataStackContextProvider
    
    init(with coreDataStack: CoreDataStackContextProvider) {
        self.coreDataStack = coreDataStack
    }
        
    func loadProfileData(completion: @escaping (Profile?, Error?) -> Void) {
        var profile: Profile?
        if let context = coreDataStack.mainContext {
            if let user = User.findOrInsertUser(in: context, with: appUserId) {
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
            if let user = User.findOrInsertUser(in: context, with: appUserId) {
                user.name = profile.name
                user.userInfo = profile.userInfo
                user.userPicture = UIImageJPEGRepresentation(profile.userPicture, 1.0) as NSData?
            }
            
            coreDataStack.performSave(context: context, completionHandler: completion)
        }
    }
}

