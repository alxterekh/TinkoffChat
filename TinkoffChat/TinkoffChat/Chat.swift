//
//  Chat.swift
//  TinkoffChat
//
//  Created by Alexander on 27/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class Chat: NSObject {
    
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool = false
    var hasUnreadMessages: Bool = false
    
    // MARK: - This shit only for testing  ¯\_(ツ)_/¯
    let messageDataProvider = MessageDataProvider()
    
//    var messageDataProvider: ()->[Message] = {
//        let firstMessage = Message()
//        firstMessage.text = "L"
//        let secondMessage = Message()
//        secondMessage.text = "Lorem ipsum dolor sit amet, pe"
//        let thirdMessage = Message()
//        thirdMessage.text = "Lorem ipsum dolor sit amet, persecuti dissentias persequeris ut ius. Iudico evertitur accommodare usu ex, vel at atqui facer. Ferri adversarium ad quo, no cum similique constituam. Exerci intellegat reprimique an vel, est ei impetus sanctus vulputate, praesent scripserit liberavisse mel an. Est salu"
//        
//        return [firstMessage, secondMessage, secondMessage] as [Message]
//    }
    
    var incomingMessages : [Message] = {
       return messageDataProvider.createMessagesSampleData()
    }()
    
    lazy var outgoingMessages : [Message] = {
        return messageDataProvider.createMessagesSampleData()
    }()
}

