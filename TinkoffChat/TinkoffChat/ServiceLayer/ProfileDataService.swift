//
//  ProfileDataService.swift
//  TinkoffChat
//
//  Created by Alexander on 17/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

protocol ProfileDataStorage {
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void)
    func loadProfileData(completion: @escaping (Profile?, Error?) -> Void)
}

class ProfileDataService : ProfileDataStorage {
    
    fileprivate let dataStore: DataStore
    
    init(dataStore: DataStore) {
        self.dataStore = dataStore
    }
    
    func loadProfileData(completion: @escaping (Profile?, Error?) -> Void) {
        dataStore.loadProfileData(completion: completion)
    }
    
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void) {
        dataStore.saveProfileData(profile, completion: completion)
    }
}

