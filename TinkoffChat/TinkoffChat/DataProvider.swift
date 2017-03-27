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
    let messages = ["Hello world!", "Lorem ipsum dolor sit amet, persecuti dissentias persequeris ut ius. Iudico evertitur accommodare usu ex, vel at atqui facer."]
    let dates = [Date(), Date(timeIntervalSinceReferenceDate: -123456789.0)]
    
    func randomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }

    func createSampleDataForOnlineConversation() -> [Chat] {
        var onlineChats = [Chat]()
        
        for name in names {
            let message = messages[Int(arc4random_uniform(2))]
            let hasUnreadMessages = randomBool()
            let date = dates[Int(arc4random_uniform(2))]
            let chat = createOnlineChatWith(name:name, message:message, date: date, hasUnreadMessages:hasUnreadMessages)
            onlineChats.append(chat)
        }
        return onlineChats
    }
    
    func createOnlineChatWith(name:String, message:String?, date: Date, hasUnreadMessages: Bool) -> Chat {
        let chat = createBaseOnlineChatTemplate()
        chat.name = name
        chat.message = message
        chat.date = date
        chat.hasUnreadMessages = hasUnreadMessages
        return chat
    }
    
    func createBaseOfflineChatTemplate() -> Chat {
        let chat = Chat()
        chat.incomingMessages = createMessagesSampleData()
        chat.outgoingMessages = createMessagesSampleData()
        chat.online = false
        
        return chat
    }
    
    func createBaseOnlineChatTemplate() -> Chat {
        let chat = Chat()
        chat.incomingMessages = createMessagesSampleData()
        chat.outgoingMessages = createMessagesSampleData()
        chat.online = true

        return chat
    }
    
    func createMessagesSampleData() -> [Message] {
        let firstMessage = Message()
        firstMessage.text = "L"
        let secondMessage = Message()
        secondMessage.text = "Lorem ipsum dolor sit amet, pe"
        let thirdMessage = Message()
        thirdMessage.text = "Lorem ipsum dolor sit amet, persecuti dissentias persequeris ut ius. Iudico evertitur accommodare usu ex, vel at atqui facer. Ferri adversarium ad quo, no cum similique constituam. Exerci intellegat reprimique an vel, est ei impetus sanctus vulputate, praesent scripserit liberavisse mel an. Est salu"
        
        return [firstMessage, secondMessage, secondMessage] as [Message]
    }
}
