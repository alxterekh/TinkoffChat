//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class GCDBasedDataOperator: NSObject, DataStore {
    
    fileprivate var dataStore = FileBasedDataStore()
    fileprivate let queue = DispatchQueue(label: "dataManagerQueue")
        
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void) {
        queue.async {
            do {
                try self.dataStore.saveProfileData(profile)
                DispatchQueue.main.async { completion(true, nil) }
            }
            catch {
                DispatchQueue.main.async { completion(false, error) }
            }
        }
    }
    
    func loadProfileData(completion: @escaping (Profile?, Error?) -> Void) {
        queue.async {
            do {
               let profile = try self.dataStore.loadProfileData()
                DispatchQueue.main.async { completion(profile, nil) }
            }
            catch {
                DispatchQueue.main.async { completion(nil, error) }
            }
        }
    }
}
