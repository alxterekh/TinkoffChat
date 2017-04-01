//
//  DataManager.swift
//  TinkoffChat
//
//  Created by Alexander on 31/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

protocol DataOperator {
    
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool) -> Void)
    func loadProfileData(completion: @escaping (Profile?) -> Void)
}
