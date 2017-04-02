//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class SaveDataOperation: Operation {
    
    fileprivate let profile: Profile
    fileprivate let completion: (Bool) -> Void
    fileprivate let dataStore: FileBasedDataStore
        
    init(with profile: Profile, dataStore: FileBasedDataStore,completion: @escaping (Bool) -> Void) {
        self.profile = profile
        self.dataStore = dataStore
        self.completion = completion
    }
    
    override func main() {

        if self.isCancelled {
            return
        }
        
        do {
            try self.dataStore.saveProfileData(profile)
            DispatchQueue.main.async {
                self.completion(true)
            }
        }
        catch {
            completion(false)
        }
    }
}

class LoadDataOperation: Operation {
    
    fileprivate let completion: (Profile?) -> Void
    fileprivate let dataStore: FileBasedDataStore
    
    init(with dataStore: FileBasedDataStore, completion: @escaping (Profile?) -> Void) {
        self.completion = completion
        self.dataStore = dataStore
    }
    
    override func main() {
        
        if self.isCancelled {
            return
        }
        
        do {
            let profile = try self.dataStore.loadProfileData()
            DispatchQueue.main.async {
                self.completion(profile)
            }
        }
        catch {
            completion(nil)
        }
    }
}

class OperationBasedDataOperator: NSObject, DataStore {
    
    fileprivate let queue = OperationQueue()
    fileprivate let dataStore = FileBasedDataStore()
    
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool) -> Void) {
        let operation = SaveDataOperation(with: profile, dataStore: dataStore, completion: completion)
        queue.addOperation(operation)
    }
    
    func loadProfileData(completion: @escaping (Profile?) -> Void) {
        let operation = LoadDataOperation(with: dataStore, completion: completion)
        queue.addOperation(operation)
    }
}
