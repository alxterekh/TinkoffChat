//
//  Conversation+CoreDataClass.swift
//  TinkoffChat
//
//  Created by Alexander on 13/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import CoreData


public class Conversation: NSManagedObject {
    
    static func fetchRequestConversation(model: NSManagedObjectModel, identifier: String) -> NSFetchRequest<Conversation>? {
        let templateName = "ConversationWithId"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["identifier" : identifier]) as? NSFetchRequest<Conversation> else {
            assert(false, "No template with name \(templateName)")
            
            return nil
        }
        
        return fetchRequest
    }
    
    func hasUnreadMessages() -> Bool {
        var hasUnreadMessages = false
        if let messages = messages as? Set<Message> {
            hasUnreadMessages = messages.filter { $0.isUnread }.count > 0
        }
        
        return hasUnreadMessages
    }
    
    var name: String? {
        return participant?.name
    }
    
    static func findOrInsertConversation(in context: NSManagedObjectContext, with identifier: String) -> Conversation? {
        var conversation: Conversation?
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("No managed object model in context!")
            assert(false)
            
            return nil
        }
        
        guard let fetchRequest = Conversation.fetchRequestConversation(model: model, identifier: identifier) else {
            
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            if let foundConversation = results.first {
                conversation = foundConversation
            }
        }
        catch {
            print("Failed to fetch Conversation")
        }
        
        if conversation == nil {
            conversation = Conversation(context: context)
            conversation?.conversationId = identifier
        }
        
        return conversation
    }
}
