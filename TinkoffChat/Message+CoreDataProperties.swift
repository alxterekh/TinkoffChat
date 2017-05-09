//
//  Message+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Alexander on 08/05/2017.
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
    @NSManaged public var isOutcoming: Bool
    @NSManaged public var lastMessageAppUser: AppUser?
    @NSManaged public var conversation: Conversation?
    @NSManaged public var lastMessageInConversation: Conversation?
    @NSManaged public var unreadInConversation: Conversation?

}
