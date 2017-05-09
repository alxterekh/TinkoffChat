//
//  ConversationsListDataStorageService.swift
//  TinkoffChat
//
//  Created by Alexander on 08/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//


//class Message: NSObject {
//    
//    private(set) var text: String?
//    private(set) var date: Date?
//    private(set) var isOutcoming: Bool = false
//    private(set) var isUnread: Bool = true
//    
//    init(with text: String, date: Date, isOutcoming: Bool) {
//        self.text = text
//        self.date = date
//        self.isOutcoming = isOutcoming
//        super.init()
//    }
//    
//    func markAsRead() {
//        isUnread = false
//    }
//}


import Foundation
import CoreData

extension Conversation {
    static func fetchRequestConversation(model: NSManagedObjectModel, identifier: String) -> NSFetchRequest<Conversation>? {
        let templateName = "Conversation"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["identifier" : identifier]) as? NSFetchRequest<Conversation> else {
            assert(false, "No template with name \(templateName)")
            
            return nil
        }
        
        return fetchRequest
    }
}

extension User {
    static func fetchRequestUser(model: NSManagedObjectModel, identifier: String) -> NSFetchRequest<User>? {
        let templateName = "UserWithId"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["identifier" : identifier]) as? NSFetchRequest<User> else {
            assert(false, "No template with name \(templateName)")
            
            return nil
        }
        
        return fetchRequest
    }
}

class ConversationStorageService {
    
    let coreDataStack: CoreDataStackContextProvider
    
    init(with coreDataStack: CoreDataStackContextProvider) {
        self.coreDataStack = coreDataStack
    }
    
    func handleFoundUser(with identifier: String, userName: String?) {
        if let context = coreDataStack.saveContext {
            if let conversation = findOrInsertConversation(in: context, with: identifier) {
                conversation.isOnline = true
                
                
                
                performSave(context: context)
            }
        }
    }
   
    func handleLostUser(with identifier: String) {
        
    }
    
    func receiveMessage(text: String, fromUser: String, toUser:String) {
        
    }
    
    fileprivate func findOrInsertUser(in context: NSManagedObjectContext, with identidier: String, userName: String) -> User? {
        var user: User?
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("No managed object model in context!")
            assert(false)
            
            return nil
        }
        
        guard let fetchRequest = User.fetchRequestUser(model: model, identifier: identidier) else {
            
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            if let foundUser = results.first {
                user = foundUser
            }
        }
        catch {
            print("Failed to fetch User with Id")
        }
        
        if user == nil {
            user = insertUser(in: context)
            user?.userId = identidier
        }
        
        user?.name = userName
        
        return user
    }
    
    fileprivate func insertUser(in context: NSManagedObjectContext) -> User? {
        return User(context: context)
    }
    
    // MARK: -
    
    fileprivate func findOrInsertConversation(in context: NSManagedObjectContext, with identifier: String) -> Conversation? {
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
            conversation = insertConversation(in: context)
            conversation?.conversationId = identifier
        }
        
        return conversation
    }
    
    fileprivate func insertConversation(in context: NSManagedObjectContext) -> Conversation? {
        return Conversation(context: context)
        //NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation
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
