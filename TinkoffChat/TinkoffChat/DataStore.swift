//
//  DataManager.swift
//  TinkoffChat
//
//  Created by Alexander on 31/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

protocol DataStore {
    
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void)
    func loadProfileData(completion: @escaping (Profile?, Error?) -> Void)
}
