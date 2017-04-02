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
    fileprivate let completion: (Bool, Error?) -> Void
    fileprivate let dataStore: FileBasedDataStore
        
    init(with profile: Profile, dataStore: FileBasedDataStore,completion: @escaping (Bool, Error?) -> Void) {
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
                self.completion(true, nil)
            }
        }
        catch {
            DispatchQueue.main.async {
                self.completion(false, error)
            }
        }
    }
}

class LoadDataOperation: Operation {
    
    fileprivate let completion: (Profile?, Error?) -> Void
    fileprivate let dataStore: FileBasedDataStore
    
    init(with dataStore: FileBasedDataStore, completion: @escaping (Profile?, Error?) -> Void) {
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
                self.completion(profile, nil)
            }
        }
        catch {
            DispatchQueue.main.async {
                self.completion(nil, error)
            }
        }
    }
}

class OperationBasedDataOperator: NSObject, DataStore {
    
    fileprivate let queue = OperationQueue()
    fileprivate let dataStore = FileBasedDataStore()
    
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void) {
        let operation = SaveDataOperation(with: profile, dataStore: dataStore, completion: completion)
        queue.addOperation(operation)
    }
    
    func loadProfileData(completion: @escaping (Profile?, Error?) -> Void) {
        let operation = LoadDataOperation(with: dataStore, completion: completion)
        queue.addOperation(operation)
    }
}
