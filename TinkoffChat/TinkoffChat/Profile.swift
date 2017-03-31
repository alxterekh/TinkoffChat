//
//  Profile.swift
//  TinkoffChat
//
//  Created by Alexander on 30/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class Profile: NSObject {
    
    var name: String?
    var userinfo: String?
    var textColor: UIColor?
    var avatarImage: UIImage
    
    override init() {
        avatarImage = #imageLiteral(resourceName: "placeholder")
        super.init()
    }
}
