//
//  Profile.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

struct Profile {
    let name: String
    let userInfo: String
    let userPicture: UIImage
    
    func hasDefaultUserPicture() -> Bool {
        return self.userPicture == #imageLiteral(resourceName: "placeholder")
    }
    
    static func createDefaultProfile() -> Profile {
        let name = ""
        let userInfo = "No user info."
        return Profile(name: name, userInfo: userInfo, userPicture: #imageLiteral(resourceName: "placeholder"))
    }
    
    func createCopyWithChange(name: String? = nil, userInfo: String? = nil, userPicture: UIImage? = nil) -> Profile {
        
        let copyName = name ?? self.name
        let copyUserInfo = userInfo ?? self.userInfo
        let copyUserPicture = userPicture ?? self.userPicture
        
        return Profile(name: copyName, userInfo: copyUserInfo, userPicture: copyUserPicture)
    }
}
