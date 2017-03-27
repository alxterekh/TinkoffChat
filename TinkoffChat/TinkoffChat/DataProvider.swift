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
        chat.name = "Oleg"
        chat.message = "Hello world!"
        chat.date = Date()
        chat.online = true
        chat.hasUnreadMessages = true
        onlineChats.append(chat)
        
        
        chats.append(onlineChats)
    }
    
    
    
    
    
    
    
    }
