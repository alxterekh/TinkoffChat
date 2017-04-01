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
    fileprivate let dataExtractor: DataExtractor
    
    init(with profile: Profile, dataExtracor: DataExtractor,completion: @escaping (Bool) -> Void) {
        self.profile = profile
        self.dataExtractor = dataExtracor
        self.completion = completion
    }
    
    override func main() {

        if self.isCancelled {
            return
        }
        
        let succees = self.dataExtractor.saveProfileData(profile)
        
        if self.isCancelled {
        
            return
        }
        
        OperationQueue.main.addOperation({
            self.completion(succees)
        })

    }
}

class LoadDataOperation: Operation {
    
    fileprivate let completion: (Profile?) -> Void
    fileprivate let dataExtractor: DataExtractor
    
    init(with dataExtractor: DataExtractor, completion: @escaping (Profile?) -> Void) {
        self.completion = completion
        self.dataExtractor = dataExtractor
    }
    
    override func main() {
        
        if self.isCancelled {
            return
        }
        
        do {
            let profile = try self.dataExtractor.loadProfileData()
            DispatchQueue.main.async {
                self.completion(profile)
            }
        }
        catch {
            completion(nil)
            print("No profile")
        }
    }
}

class OperationBasedDataOperator: NSObject, DataOperator {
    
    fileprivate let queue = OperationQueue()
    fileprivate let dataExtractor = DataExtractor()
    
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool) -> Void) {
        let operation = SaveDataOperation(with: profile, dataExtracor: dataExtractor, completion: completion)
        queue.addOperation(operation)
    }
    
    func loadProfileData(completion: @escaping (Profile?) -> Void) {
        let operation = LoadDataOperation(with: dataExtractor, completion: completion)
        queue.addOperation(operation)
    }
}
