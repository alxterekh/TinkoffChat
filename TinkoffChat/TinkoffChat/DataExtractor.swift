//
//  DataDispatcher.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class DataExtracor {
    
    let avatarKey = "avatarKey"
    let nameKey = "nameKey"
    let userInfoKey = "userInfoKey"
    let textColorKey = "textColorKey"
    
    let fileName = "profileData"
    let fileManager = FileManager.default
    
    func serializeProfileData(_ profile: Profile) -> Dictionary<String, Any> {
        let avatarImageData = NSKeyedArchiver.archivedData(withRootObject: profile.userPicture)
        let textColorData = NSKeyedArchiver.archivedData(withRootObject: profile.textColor)
        
        return [avatarKey: avatarImageData,
                nameKey: profile.name,
                userInfoKey: profile.userInfo,
                textColorKey: textColorData]
    }
    
    func desirializeProfileData(_ data: Data) -> Profile {
        let dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String : Any]
        let name = dictionary[nameKey] as! String
        let userInfo = dictionary[userInfoKey] as! String
        let userPicture = NSKeyedUnarchiver.unarchiveObject(with: dictionary[avatarKey] as! Data) as! UIImage
        let textColor = NSKeyedUnarchiver.unarchiveObject(with: dictionary[textColorKey] as! Data) as! UIColor
    
        return Profile(name: name, userInfo: userInfo, textColor: textColor, userPicture: userPicture)
    }

    func saveProfileData(_ profile: Profile) -> Bool {
        var result = false
        let dataDicionary = serializeProfileData(profile)
        let data = NSKeyedArchiver.archivedData(withRootObject: dataDicionary)
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            try data.write(to: filePath)
            result = true
        }
        catch {
            print("Couldn't write file")
        }
        return result
    }

    func loadProfileData() -> Profile? {
        var profile: Profile?
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        if fileManager.fileExists(atPath: filePath.path) {
            do {
                let data = try Data(contentsOf: filePath)
                profile = desirializeProfileData(data)
            }
            catch {
                print("Couldn't remove file")
            }
        }
   
        return profile
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
 }
