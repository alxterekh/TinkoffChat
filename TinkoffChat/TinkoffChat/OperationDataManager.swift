//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

//class MyOperation: Operation {
//    
//    let profile: Profile
//    var dataDisaptcher = DataDispatcher()
//    
//    init(with profile: Profile) {
//        self.profile = profile
//    }
//    
//    override func main() {
//
//        if self.isCancelled {
//            return
//        }
//        
//        let succees = self.dataDisaptcher.saveProfileData(profile)
//        
//        if self.isCancelled {
//        
//            return
//        }
//    }
//}

class OperationDataManager: NSObject {
    
    var dataDisaptcher = DataDispatcher()
    
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool) -> Void) {
        let queue = OperationQueue()
        let operation = BlockOperation(block: {
            let succees = self.dataDisaptcher.saveProfileData(profile)
            OperationQueue.main.addOperation({
                completion(succees)
            })
        })
        queue.addOperation(operation)
    }
    
    func unloadProfileData(completion: @escaping (Profile?) -> Void) {
        let queue = OperationQueue()
        let operation = BlockOperation(block: {
        let profile = self.dataDisaptcher.unloadProfileData()
            OperationQueue.main.addOperation({
                completion(profile)
            })
        })
        queue.addOperation(operation)
    }
}
