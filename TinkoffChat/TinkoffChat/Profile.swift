//
//  Profile.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

extension Profile: Equatable {}

func ==(lhs: Profile, rhs: Profile) -> Bool {
    return lhs.name == rhs.name &&
        lhs.userInfo == rhs.userInfo &&
        lhs.textColor == rhs.textColor &&
        lhs.userPicture == rhs.userPicture
}

struct Profile {
    let name: String
    let userInfo: String
    let textColor: UIColor
    let userPicture: UIImage
    
    func hasDefaultUserPicture() -> Bool {
        return self.userPicture == #imageLiteral(resourceName: "placeholder")
    }
    
    static func createDefaultProfile() -> Profile {
        let name = UIDevice.current.name
        let userInfo = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        return Profile(name: name, userInfo: userInfo, textColor: UIColor.black, userPicture: #imageLiteral(resourceName: "placeholder"))
    }

    func createCopyWithChange(name: String? = nil, userInfo: String? = nil, textColor: UIColor? = nil, userPicture: UIImage? = nil) -> Profile {
    
        let copyName = name ?? self.name
        let copyUserInfo = userInfo ?? self.userInfo
        let copyTextColor = textColor ?? self.textColor
        let copyUserPicture = userPicture ?? self.userPicture
        
        return Profile(name: copyName, userInfo: copyUserInfo, textColor: copyTextColor, userPicture: copyUserPicture)
    }
}
