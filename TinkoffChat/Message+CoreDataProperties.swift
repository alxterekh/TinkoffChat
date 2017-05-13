//
//  Message+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Alexander on 13/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var isOutgoing: Bool
    @NSManaged public var isUnread: Bool
    @NSManaged public var messageId: String?
    @NSManaged public var text: String?
    @NSManaged public var conversation: Conversation?
    @NSManaged public var lastMessageInConversation: Conversation?

}
