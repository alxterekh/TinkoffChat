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
    let userinfoKey = "userinfoKey"
    let textColorKey = "textColorKey"
    
    let fileName = "profileData"
    
    let fileManager = FileManager.default
    
    func serializeProfileData(_ profile: Profile) -> Dictionary<String, Any> {
        let avatarImageData = UIImageJPEGRepresentation(profile.avatarImage, 0) as! NSData
        let textColorData = NSKeyedArchiver.archivedData(withRootObject: profile.textColor) as NSData
        
        return [avatarKey: avatarImageData,
                nameKey: profile.name,
                userinfoKey: profile.userinfo,
                textColorKey: textColorData]
    }
    
    func desirializeProfileData(_ data: Data) -> Profile {
        let dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String : Any]
        let profile = Profile()
        profile.name = dictionary[nameKey] as! String
        profile.userinfo = dictionary[userinfoKey] as! String
        profile.avatarImage = UIImage(data: dictionary[avatarKey] as! Data) as UIImage!
        //profile.textColor = (NSKeyedUnarchiver.unarchiveObject(with: dictionary[avatarKey] as! Data)) as! UIColor
        
        return profile
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

    func unloadProfileData() -> Profile? {
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
