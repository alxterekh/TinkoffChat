//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class GCDDataManager: NSObject {
    
    var dataDisaptcher = DataDispatcher()
        
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool) -> Void) {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async{
           //save
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
    
    func unloadProfileData() {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async{
            //save
            DispatchQueue.main.async {
            }
        }
    }
}
