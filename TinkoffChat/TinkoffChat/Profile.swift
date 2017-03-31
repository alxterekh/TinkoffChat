//
//  Profile.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class Profile: NSObject {
    
    var name = ""
    var userinfo = ""
    var textColor = UIColor.black
    var avatarImage = #imageLiteral(resourceName: "placeholder")
    
//    required convenience init(coder decoder: NSCoder) {
//        self.name = decoder.decodeObject(forKey: "name") as! String
//        self.userinfo = decoder.decodeObject(forKey: "userinfo") as! String 
//        self.textColor = decoder.decodeObject(forKey: "textColor") as! UIColor
//        self.avatarImage = decoder.decodeObject(forKey: "avatarImage") as! UIImage
//    }
//    
//    func encode(with coder: NSCoder) {
//        coder.encode(name, forKey: "name")
//        coder.encode(userinfo, forKey: "userinfo")
//        coder.encode(textColor, forKey: "textColor")
//        coder.encode(avatarImage, forKey: "avatarImage")
//    }
}
