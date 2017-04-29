//
//  User+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Alexander on 29/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var userInfo: String?
    @NSManaged public var userPicture: NSData?
    @NSManaged public var userId: String?

}
