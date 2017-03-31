//
//  DataDispatcher.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class DataDispatcher {
    
    let filename = "profileData"
    
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool) -> Void) {}
    func unloadProfileData(completion: @escaping (Bool) -> Void) {}
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func saveProfileData(_ profile: Profile) -> Bool {
        let data = NSKeyedArchiver.archivedData(withRootObject: profile)
        let path = getDocumentsDirectory().appendingPathComponent(filename)
        var result = false
        do {
            try data.write(to: path)
            result = true
        } catch {
            print("Couldn't write file")
        }
        return result
    }

    func unloadProfileData() -> Profile? {
        var profileData: Profile?
        let path = getDocumentsDirectory().appendingPathComponent(filename)
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: path.absoluteString) as? Profile {
            profileData = data
        }
        return profileData
    }
}
