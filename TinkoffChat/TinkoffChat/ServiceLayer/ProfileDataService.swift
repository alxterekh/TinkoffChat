//
//  ProfileDataService.swift
//  TinkoffChat
//
//  Created by Alexander on 17/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

enum DataStoreType {
    case GCDBasedDataStoreType
    case OperationBasedDataStoreType
}

protocol ProfileData {
    func saveProfileData(_ profile: Profile, dataStoreType: DataStoreType, completion: @escaping (Bool, Error?) -> Void)
    func loadProfileData(completion: @escaping (Profile?, Error?) -> Void)
}

class ProfileDataService : ProfileData {
    
    fileprivate let gcdBasedDataStore: DataStore
    fileprivate let operationBasedDataStore: DataStore
    
    init(gcdBasedDataStore: DataStore, operationBasedDataStore: DataStore) {
        self.gcdBasedDataStore = gcdBasedDataStore
        self.operationBasedDataStore = operationBasedDataStore
    }
    
    func loadProfileData(completion: @escaping (Profile?, Error?) -> Void) {
        getRandomDataStore().loadProfileData(completion: completion)
    }
    
    func saveProfileData(_ profile: Profile, dataStoreType: DataStoreType, completion: @escaping (Bool, Error?) -> Void) {
        switch dataStoreType {
        case DataStoreType.GCDBasedDataStoreType:
            gcdBasedDataStore.saveProfileData(profile, completion: completion)
            
        case DataStoreType.OperationBasedDataStoreType:
            operationBasedDataStore.saveProfileData(profile, completion: completion)
        }
    }
    
    fileprivate func getRandomDataStore() -> DataStore {
        let dataOperators = [gcdBasedDataStore, operationBasedDataStore] as [DataStore]
        return dataOperators[Int(arc4random_uniform(2))]
    }
}
