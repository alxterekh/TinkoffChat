//
//  DataDispatcher.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class DataDispatcher {
    
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool) -> Void) {}
    func unloadProfileData(completion: @escaping (Bool) -> Void) {}

    let fileManager = FileManager.default

    func saveProfileData(_ profile: Profile) -> Bool {
        var result = false
        if let data = UIImagePNGRepresentation(profile.avatarImage) {
            let filename = getDocumentsDirectory().appendingPathComponent("avatar.png")
            do {
                try data.write(to: filename)
                result = true
            }
            catch {
                 print("Couldn't write file")
            }
        }
        return result
    }
    
    func unloadProfileData() -> Profile? {
        let profile = Profile()
        let path = getDocumentsDirectory().appendingPathComponent("avatar.png")
        if let image = UIImage(contentsOfFile: path.path) {
             profile.avatarImage = image
        }
        return profile
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
 }
