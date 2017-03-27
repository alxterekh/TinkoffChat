//
//  DataProvider.swift
//  TinkoffChat
//
//  Created by Alexander on 27/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class DataProvider: NSObject {
   
    let names = ["Oleg", "Egor", "Vika", "Tolya", "Ilya", "Serega", "Masha", "Zhiraph", "Ezh", "Phyton"]
    
    let messages = ["Lorem ipsum dolor", "Lorem ipsum dolor sit amet, persecuti dissentias persequeris ut ius. Iudico evertitur accommodare usu ex, vel at atqui facer.", "No messages yet"]
    
    let dates = [Date(), Date(timeIntervalSinceReferenceDate: -123456789.0)]
    
     // MARK: - 
    
    func createSampleDataForConversation() -> [[Chat]] {
        var onlineChats = [Chat]()
        var offlineChats = [Chat]()
        
        for name in names {
            let onlineMessage = messages[Int(arc4random_uniform(3))]
            let historyMessage = messages[Int(arc4random_uniform(2))]
            let hasUnreadMessages = randomBool()
            let date = dates[Int(arc4random_uniform(2))]
            onlineChats.append(createOnlineChatWith(name:name, message:onlineMessage, date: date, hasUnreadMessages:hasUnreadMessages))
            offlineChats.append(createOfflineChatWith(name:name, message:historyMessage, date: date, hasUnreadMessages:hasUnreadMessages))
        }
        let chats = [onlineChats, offlineChats]
        return chats
    }
    
    func createOnlineChatWith(name:String, message:String?, date: Date, hasUnreadMessages: Bool) -> Chat {
        let chat = createChatWith(name:name, message:message, date: date, hasUnreadMessages: hasUnreadMessages)
        if message == "No messages yet" {
            chat.message = nil
            chat.date = nil
        }
        chat.online = true
        return chat
    }
    
    func createOfflineChatWith(name:String, message:String?, date: Date, hasUnreadMessages: Bool) -> Chat {
        let chat = createChatWith(name:name, message:message, date: date, hasUnreadMessages: hasUnreadMessages)
        chat.online = false
        return chat
    }
    
    func createChatWith(name:String, message:String?, date: Date, hasUnreadMessages: Bool) -> Chat {
        let chat = Chat()
        chat.name = name
        chat.message = message
        chat.date = date
        chat.hasUnreadMessages = hasUnreadMessages
        chat.incomingMessages = createMessagesSampleData()
        chat.outgoingMessages = createMessagesSampleData()
        
        return chat
    }
    
    func createMessagesSampleData() -> [Message] {
        var messages = [Message]()
        let messageTexts = ["L", "Lorem ipsum dolor sit amet, pe", "Lorem ipsum dolor sit amet, persecuti dissentias persequeris ut ius. Iudico evertitur accommodare usu ex, vel at atqui facer. Ferri adversarium ad quo, no cum similique constituam. Exerci intellegat reprimique an vel, est ei impetus sanctus vulputate, praesent scripserit liberavisse mel an. Est salu"]
        for text in messageTexts {
            let message = Message()
            message.text = text
            messages.append(message)
        }
        
        return messages
    }
    
    // MARK: - Help methods
    
    func randomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }
}


