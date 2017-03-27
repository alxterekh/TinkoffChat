//
//  DataProvider.swift
//  TinkoffChat
//
//  Created by Alexander on 27/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class DataProvider: NSObject {
    
    var chats:Array<Array<Chat>> = Array<Array<Chat>>()
    
    override init() {
        super.init()
        createSampleDataForOnlineConversation()
    }
    
    func createSampleDataForOnlineConversation() {
        var onlineChats = [Chat]()
        
        var chat = Chat()
        chat.name = "Tinkoff"
        chat.message = "Hello world!"
        chat.date = Date()
        chat.online = true
        chat.hasUnreadMessages = true
        chat.incomingMessages = createMessagesSampleData()
        chat.outgoingMessages = createMessagesSampleData()
        
        onlineChats.append(chat)
        chats.append(onlineChats)
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
