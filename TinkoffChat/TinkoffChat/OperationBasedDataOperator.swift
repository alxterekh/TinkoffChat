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
    let dataExtracor: DataExtracor
    
    init(with profile: Profile, dataExtracor: DataExtracor,completion: @escaping (Bool) -> Void) {
        self.profile = profile
        self.dataExtracor = dataExtracor
        self.completion = completion
    }
    
    override func main() {

        if self.isCancelled {
            return
        }
        
        let succees = self.dataExtracor.saveProfileData(profile)
        
        if self.isCancelled {
        
            return
        }
        
        OperationQueue.main.addOperation({
            self.completion(succees)
        })

    }
}

class LoadDataOperation: Operation {
    
    let completion: (Profile) -> Void
    let dataExtracor: DataExtracor
    
    init(with dataExtracor: DataExtracor, completion: @escaping (Profile) -> Void) {
        self.completion = completion
        self.dataExtracor = dataExtracor
    }
    
    override func main() {
        
        if self.isCancelled {
            return
        }
        
        if let data = self.dataExtracor.loadProfileData() {
            if self.isCancelled {
                
                return
            }
            OperationQueue.main.addOperation({
                self.completion(data)
            })
        }
    }
}

class OperationBasedDataOperator: NSObject, DataManager {
    
    let queue = OperationQueue()
    let dataExtractor = DataExtracor()
    
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool) -> Void) {
        let operation = SaveDataOperation(with: profile, dataExtracor: dataExtractor, completion: completion)
        queue.addOperation(operation)
    }
    
    func loadProfileData(completion: @escaping (Profile) -> Void) {
        let operation = LoadDataOperation(with: dataExtractor, completion: completion)
        queue.addOperation(operation)
    }
}
