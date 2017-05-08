//
//  Message+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Alexander on 07/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var messageId: String?
    @NSManaged public var text: String?

}
