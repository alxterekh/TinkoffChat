//
//  Conversation+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Alexander on 08/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import CoreData


extension Conversation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversation> {
        return NSFetchRequest<Conversation>(entityName: "Conversation")
    }

    @NSManaged public var conversationId: String?
    @NSManaged public var isOnline: Bool
    @NSManaged public var appUser: AppUser?
    @NSManaged public var messages: NSSet?
    @NSManaged public var lastMessage: Message?
    @NSManaged public var unreadMessages: NSSet?
    @NSManaged public var participants: NSSet?

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

// MARK: Generated accessors for unreadMessages
extension Conversation {

    @objc(addUnreadMessagesObject:)
    @NSManaged public func addToUnreadMessages(_ value: Message)

    @objc(removeUnreadMessagesObject:)
    @NSManaged public func removeFromUnreadMessages(_ value: Message)

    @objc(addUnreadMessages:)
    @NSManaged public func addToUnreadMessages(_ values: NSSet)

    @objc(removeUnreadMessages:)
    @NSManaged public func removeFromUnreadMessages(_ values: NSSet)

}

// MARK: Generated accessors for participants
extension Conversation {

    @objc(addParticipantsObject:)
    @NSManaged public func addToParticipants(_ value: User)

    @objc(removeParticipantsObject:)
    @NSManaged public func removeFromParticipants(_ value: User)

    @objc(addParticipants:)
    @NSManaged public func addToParticipants(_ values: NSSet)

    @objc(removeParticipants:)
    @NSManaged public func removeFromParticipants(_ values: NSSet)

}
