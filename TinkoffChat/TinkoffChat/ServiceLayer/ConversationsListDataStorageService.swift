//
//  ConversationsListDataStorageService.swift
//  TinkoffChat
//
//  Created by Alexander on 08/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import CoreData

extension Conversation {
    static func fetchRequestConversation(model: NSManagedObjectModel) -> NSFetchRequest<Conversation>? {
        let templateName = "Conversation"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<Conversation> else {
            assert(false, "No template with name \(templateName)")
            
            return nil
        }
        
        return fetchRequest
    }
}

class ConversationsListDataStorageService {
    
    fileprivate let coreDataStack: CoreDataStackContextProvider = CoreDataStack()
    
    func addConversation(with identifier: String) {
        var conversation: Conversation?
        if let context = coreDataStack.saveContext {
            conversation = findOrInsertConversation(in: context, with: identifier)
            conversation?.isOnline = true
            performSave(context: context)
        }
    }
    
    // MARK: -
    
    fileprivate func findOrInsertConversation(in context: NSManagedObjectContext, with identifier: String) -> Conversation? {
        var conversation: Conversation?
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("No managed object model in context!")
            assert(false)
            
            return nil
        }
        
        guard let fetchRequest = Conversation.fetchRequestConversation(model: model) else {
            
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
            conversation = insertConversation(in: context)
            conversation?.conversationId = identifier
        }
        
        return conversation
    }
    
    fileprivate func insertConversation(in context: NSManagedObjectContext) -> Conversation? {
        if let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation {
            
            return conversation
        }
        
        return nil
    }
    
    fileprivate func performSave(context: NSManagedObjectContext) {
        if context.hasChanges {
            context.perform {
                [weak self] in
                
                do {
                    try context.save()
                }
                catch {
                    //DispatchQueue.main.async { completionHandler(false, error) }
                    print("Context save error: \(error)")
                }
                
                if let parent = context.parent {
                    self?.performSave(context: parent)
                }
                else {
                    //DispatchQueue.main.async { completionHandler(true, nil) }
                }
            }
        }
        else {
            //completionHandler(true, nil)
        }
    }
}
