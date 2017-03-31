//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class OperationDataManager: NSObject {
    
    func saveProfileData(_ profile: Profile) {
        let queue = OperationQueue()
        let operation = BlockOperation(block: {
            //save
            OperationQueue.main.addOperation({
                //return
            })
        })
        queue.addOperation(operation)
    }
    
    func unloadProfileData() {
        let queue = OperationQueue()
        let operation = BlockOperation(block: {
            //save
            OperationQueue.main.addOperation({
                //return
            })
        })
        queue.addOperation(operation)
    }
}
