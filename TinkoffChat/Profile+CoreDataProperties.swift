//
//  Profile+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Alexander on 26/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var name: String?
    @NSManaged public var userInfo: String?
    @NSManaged public var userPicture: NSData?

}
