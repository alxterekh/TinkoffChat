//
//  User+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Alexander on 08/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var userId: String?
    @NSManaged public var userInfo: String?
    @NSManaged public var userPicture: NSData?
    @NSManaged public var isOnline: Bool
    @NSManaged public var currentAppUser: AppUser?
    @NSManaged public var appUser: AppUser?

}
