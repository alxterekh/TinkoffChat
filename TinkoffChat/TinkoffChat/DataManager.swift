//
//  DataManager.swift
//  TinkoffChat
//
//  Created by Alexander on 31/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

protocol DataManager {
    
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool) -> Void)
    func unloadProfileData(completion: @escaping (Profile?) -> Void)
}
