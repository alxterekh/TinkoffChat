//
//  DataDispatcher.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class DataExtractor {
    
    static let avatarKey = "avatarKey"
    static let nameKey = "nameKey"
    static let userInfoKey = "userInfoKey"
    static let textColorKey = "textColorKey"
    static let fileName = "profileData"
    
    enum DesirializationError: Error {
        case brokenDataDictionaty
        case brokenName
        case brokenUserInfo
        case brokenUserPicture
        case brokenTextColor
    }
    
    enum DataReadingError: Error {
        case noFile
    }
    
    fileprivate let fileManager = FileManager.default
    
    func serializeProfileData(_ profile: Profile) -> Dictionary<String, Any> {
        let avatarImageData = NSKeyedArchiver.archivedData(withRootObject: profile.userPicture)
        let textColorData = NSKeyedArchiver.archivedData(withRootObject: profile.textColor)
        
        return [DataExtractor.avatarKey: avatarImageData,
                DataExtractor.nameKey: profile.name,
                DataExtractor.userInfoKey: profile.userInfo,
                DataExtractor.textColorKey: textColorData]
    }
    
    func desirializeProfileData(_ data: Data) throws -> Profile? {
        
        guard let dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : Any] else {
            throw DesirializationError.brokenDataDictionaty
        }
        guard let name = dictionary[DataExtractor.nameKey] as? String else {
            throw DesirializationError.brokenName
        }
        guard let userInfo = dictionary[DataExtractor.userInfoKey] as? String else {
            throw DesirializationError.brokenUserInfo
        }
        
        guard let userPicture = NSKeyedUnarchiver.unarchiveObject(with: dictionary[DataExtractor.avatarKey] as! Data) as? UIImage else {
            throw DesirializationError.brokenUserPicture
        }
        
        guard let textColor = NSKeyedUnarchiver.unarchiveObject(with: dictionary[DataExtractor.textColorKey] as! Data) as? UIColor else {
            throw DesirializationError.brokenTextColor
        }

        return Profile(name: name, userInfo: userInfo, textColor: textColor, userPicture: userPicture)
    }

    func saveProfileData(_ profile: Profile) -> Bool {
        var result = false
        let dataDicionary = serializeProfileData(profile)
        let data = NSKeyedArchiver.archivedData(withRootObject: dataDicionary)
        let filePath = getDocumentsDirectory().appendingPathComponent(DataExtractor.fileName)
        do {
            try data.write(to: filePath)
            result = true
        }
        catch {
            print("Couldn't write file")
        }
        return result
    }

    func loadProfileData() throws -> Profile? {
        var profile: Profile?
        let filePath = getDocumentsDirectory().appendingPathComponent(DataExtractor.fileName)
        if fileManager.fileExists(atPath: filePath.path) {
            do {
                let data = try Data(contentsOf: filePath)
                profile =  try desirializeProfileData(data)
            }
            catch {
                print("Couldn't remove file or couldn't desirialize data")
            }
        }
        else {
            throw DataReadingError.noFile
        }
   
        return profile
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
 }
