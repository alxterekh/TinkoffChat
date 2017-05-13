//
//  Conversation+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Alexander on 13/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import CoreData


extension Conversation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversation> {
        return NSFetchRequest<Conversation>(entityName: "Conversation")
    }

    @NSManaged public var conversationId: String?
    @NSManaged public var isAbleToConversate: Bool
    @NSManaged public var lastMessage: Message?
    @NSManaged public var messages: NSSet?
    @NSManaged public var participant: User?

}

// MARK: Generated accessors for messages
extension Conversation {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}
