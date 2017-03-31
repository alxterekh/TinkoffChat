//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class OperationDataManager: NSObject {
    
    var dataDisaptcher = DataDispatcher()
    
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool) -> Void) {
        let queue = OperationQueue()
        let operation = BlockOperation(block: {
            let succes = self.dataDisaptcher.saveProfileData(profile)
            OperationQueue.main.addOperation({
                completion(succes)
            })
        })
        queue.addOperation(operation)
    }
    
    func unloadProfileData(completion: @escaping (Profile) -> Void) {
        let queue = OperationQueue()
        let operation = BlockOperation(block: {
        let profile = self.dataDisaptcher.unloadProfileData()
            OperationQueue.main.addOperation({
                if let profile = profile {
                    completion(profile)
                }            })
        })
        queue.addOperation(operation)
    }
}
