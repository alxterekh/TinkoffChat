//
//  Conversation+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Alexander on 07/05/2017.
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

}
