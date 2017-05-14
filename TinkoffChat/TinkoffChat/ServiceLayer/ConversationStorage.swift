//
//  ConversationsListDataStorageService.swift
//  TinkoffChat
//
//  Created by Alexander on 08/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import CoreData

protocol ConversationStorage {
    func handleFoundUser(with identifier: String, userName: String?)
    func handleLostUser(with identifier: String)
    func handleReceivedMessage(text: String, fromUser: String, toUser:String)
    func handleSentMessage(text: String, to conversation: Conversation)
}

class ConversationStorageService : ConversationStorage {
    
    fileprivate let coreDataStack: CoreDataStackContextProvider
    
    init(with coreDataStack: CoreDataStackContextProvider) {
        self.coreDataStack = coreDataStack
    }
    
    func handleFoundUser(with identifier: String, userName: String?) {
        if let context = coreDataStack.saveContext {
            if let conversation = Conversation.findOrInsertConversation(in: context, with: identifier) {
                conversation.isAbleToConversate = true
                if let participant = User.findOrInsertUser(in: context, with: identifier) {
                    participant.name = userName
                    participant.isOnline = true
                    conversation.participant = participant
                    coreDataStack.performSave(context: context){_,_ in }
                }
            }
        }
    }
   
    func handleLostUser(with identifier: String) {
        if let context = coreDataStack.saveContext {
            if let conversation = Conversation.findOrInsertConversation(in: context, with: identifier) {
                conversation.isAbleToConversate = false
                conversation.participant = nil
                coreDataStack.performSave(context: context){_,_ in }
            }
        }
    }
    
    func handleReceivedMessage(text: String, fromUser: String, toUser:String) {
        if let context = coreDataStack.saveContext {
            if let conversation = Conversation.findOrInsertConversation(in: context, with: fromUser) {
                let message = createMessage(with: text , context: context)
                message.isOutgoing = false
                message.isUnread = true
                message.conversation = conversation
                conversation.lastMessage = message
                conversation.addToMessages(message)
                coreDataStack.performSave(context: context){_,_ in }
            }
        }
    }
    
    func handleSentMessage(text: String, to conversation: Conversation) {
        if let context = coreDataStack.saveContext {
            let message = createMessage(with: text , context: context)
            message.isOutgoing = true
            if let conversationId = conversation.conversationId {
                if let conversation = Conversation.findOrInsertConversation(in: context, with: conversationId) {
                    message.conversation = conversation
                    conversation.lastMessage = message
                    conversation.addToMessages(message)
                    coreDataStack.performSave(context: context){_,_ in }
                }
            }
        }
    }
    
    fileprivate func createMessage(with text: String, context: NSManagedObjectContext) -> Message {
        let message = Message(context: context)
        message.messageId = IdentifierGenerator.generateIdentifier()
        message.date = NSDate()
        message.text = text
        
        return message
    }
}
