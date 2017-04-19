//
//  DataDispatcher.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

protocol ProfileStorage {
    func saveProfileData(_ profile: Profile) throws
    func loadProfileData() throws -> Profile?
}

class FileBasedDataStore {
    
    static let avatarKey = "avatarKey"
    static let nameKey = "nameKey"
    static let userInfoKey = "userInfoKey"
    static let textColorKey = "textColorKey"
    static let fileName = "profileData"
    
    enum FileBasedDataStoreError: Error {
        case brokenData
    }
    
    fileprivate let fileManager = FileManager.default
    
    fileprivate func serializeProfileData(_ profile: Profile) -> Dictionary<String, Any> {
        let avatarImageData = NSKeyedArchiver.archivedData(withRootObject: profile.userPicture)
        let textColorData = NSKeyedArchiver.archivedData(withRootObject: profile.textColor)
        
        return [FileBasedDataStore.avatarKey: avatarImageData,
                FileBasedDataStore.nameKey: profile.name,
                FileBasedDataStore.userInfoKey: profile.userInfo,
                FileBasedDataStore.textColorKey: textColorData]
    }
    
    fileprivate func deserializeProfileData(_ data: Data) throws -> Profile? {
        
        guard let dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : Any] else {
            throw FileBasedDataStoreError.brokenData
        }
        guard let name = dictionary[FileBasedDataStore.nameKey] as? String else {
            throw FileBasedDataStoreError.brokenData
        }
        guard let userInfo = dictionary[FileBasedDataStore.userInfoKey] as? String else {
            throw FileBasedDataStoreError.brokenData
        }
        
        guard let userPicture = NSKeyedUnarchiver.unarchiveObject(with: dictionary[FileBasedDataStore.avatarKey] as! Data) as? UIImage else {
            throw FileBasedDataStoreError.brokenData
        }
        
        guard let textColor = NSKeyedUnarchiver.unarchiveObject(with: dictionary[FileBasedDataStore.textColorKey] as! Data) as? UIColor else {
            throw FileBasedDataStoreError.brokenData
        }

        return Profile(name: name, userInfo: userInfo, textColor: textColor, userPicture: userPicture)
    }

    fileprivate func getDocumentsDirectory() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    fileprivate func getFilePath() -> URL {
        return getDocumentsDirectory().appendingPathComponent(FileBasedDataStore.fileName)
    }
}

extension FileBasedDataStore : ProfileStorage {
    func saveProfileData(_ profile: Profile) throws {
        let dataDicionary = serializeProfileData(profile)
        let data = NSKeyedArchiver.archivedData(withRootObject: dataDicionary)
        try data.write(to: getFilePath())
    }
    
    func loadProfileData() throws -> Profile? {
        var profile: Profile?
        guard fileManager.fileExists(atPath: getFilePath().path) else {
            throw FileBasedDataStoreError.brokenData
        }
        let data = try Data(contentsOf: getFilePath())
        profile =  try deserializeProfileData(data)
        
        return profile
    }
}
