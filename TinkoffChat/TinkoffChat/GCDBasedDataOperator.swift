//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class GCDBasedDataOperator: NSObject, DataManager {
    
    var dataExtracor = DataExtracor()
    let queue = DispatchQueue(label: "dataManagerQueue")
        
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool) -> Void) {
        queue.async{
            let succes = self.dataExtracor.saveProfileData(profile)
            DispatchQueue.main.async {
                completion(succes)
            }
        }
    }
    
    func loadProfileData(completion: @escaping (Profile) -> Void) {
        queue.async{
            if let profile = self.dataExtracor.loadProfileData() {
                DispatchQueue.main.async {
                    completion(profile)
                }
            }
        }
    }
}
