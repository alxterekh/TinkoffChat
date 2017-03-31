//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class SaveDataOperation: Operation {
    
    let profile: Profile
    let completion: (Bool) -> Void
    var dataDisaptcher = DataExtracor()
    
    init(with profile: Profile, completion: @escaping (Bool) -> Void) {
        self.profile = profile
        self.completion = completion
    }
    
    override func main() {

        if self.isCancelled {
            return
        }
        
        let succees = self.dataDisaptcher.saveProfileData(profile)
        
        if self.isCancelled {
        
            return
        }
        
        OperationQueue.main.addOperation({
            self.completion(succees)
        })

    }
}

class LoadDataOperation: Operation {
    
    let completion: (Profile?) -> Void
    var dataDisaptcher = DataExtracor()
    
    init(with completion: @escaping (Profile?) -> Void) {
        self.completion = completion
    }
    
    override func main() {
        
        if self.isCancelled {
            return
        }
        
        let data = self.dataDisaptcher.unloadProfileData()
        
        if self.isCancelled {
            
            return
        }
        
        OperationQueue.main.addOperation({
            self.completion(data)
        })
        
    }
}

class OperationDataManager: NSObject, DataManager {
        
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool) -> Void) {
        let queue = OperationQueue()
        let operation = SaveDataOperation(with: profile, completion: completion)
        queue.addOperation(operation)
    }
    
    func unloadProfileData(completion: @escaping (Profile?) -> Void) {
        let queue = OperationQueue()
        let operation = LoadDataOperation(with: completion)
        queue.addOperation(operation)
    }
}
