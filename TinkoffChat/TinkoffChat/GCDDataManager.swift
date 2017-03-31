//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class GCDDataManager: NSObject, DataManager {
    
    var dataDisaptcher = DataDispatcher()
        
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool) -> Void) {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async{
            let succes = self.dataDisaptcher.saveProfileData(profile)
            DispatchQueue.main.async {
                completion(succes)
            }
        }
    }
    
    func unloadProfileData(completion: @escaping (Profile?) -> Void) {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async{
            let profile = self.dataDisaptcher.unloadProfileData()
            DispatchQueue.main.async {
                completion(profile)
            }
        }
    }
}
