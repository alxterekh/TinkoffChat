//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class GCDBasedDataOperator: NSObject, DataOperator {
    
    fileprivate var dataExtractor = DataExtractor()
    fileprivate let queue = DispatchQueue(label: "dataManagerQueue")
        
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool) -> Void) {
        queue.async{
            let succes = self.dataExtractor.saveProfileData(profile)
            DispatchQueue.main.async {
                completion(succes)
            }
        }
    }
    
    func loadProfileData(completion: @escaping (Profile?) -> Void) {
        queue.async{
            do {
               let profile = try self.dataExtractor.loadProfileData()
                DispatchQueue.main.async {
                    completion(profile)
                }
            }
            catch {
                completion(nil)
                print("No profile")
            }
        }
    }
}
