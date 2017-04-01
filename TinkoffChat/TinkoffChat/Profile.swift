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
    let userPicture: UIImage
    let textColor: UIColor
    
    init(name: String, userInfo: String, textColor: UIColor, userPicture: UIImage) {
        self.name = name
        self.userInfo = userInfo
        self.userPicture = userPicture
        self.textColor = textColor
    }
    
    static func createDefaultProfile() -> Profile {
        let name = ""
        let userInfo = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        return Profile(name: name, userInfo: userInfo, textColor: UIColor.black, userPicture: #imageLiteral(resourceName: "placeholder"))
    }

    
    func createCopyWithChange(name: String! = nil, userInfo: String! = nil, textColor: UIColor! = nil, userPicture: UIImage! = nil) -> Profile {
        
        let copyName = name == nil ? self.name : name
        let copyUserInfo = userInfo == nil ? self.userInfo : userInfo
        let copyTextColor = textColor == nil ? self.textColor : textColor
        let copyUserPicture = userPicture == nil ? self.userPicture : userPicture
        
        return Profile(name: copyName!, userInfo: copyUserInfo!, textColor: copyTextColor!, userPicture: copyUserPicture!)
    }
}
