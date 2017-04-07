//
//  CommunicatorManager.swift
//  TinkoffChat
//
//  Created by Alexander on 07/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

protocol CommunicatorDelegate : class {
    
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    func didRecieveMessage(text: String, fromUser: String, toUser:String)
}

class CommunicatorManager: NSObject, CommunicatorDelegate {
    
    fileprivate let multipeerCommunicator = MultipeerCommunicator()
    var chats = [Chat]()

    // MARK: -
    
    override init() {
        super.init()
        setup()
    }
    
    fileprivate func setup() {
        multipeerCommunicator.delegate = self
    }
    
    func createChatWith(name:String, message:String?, date: Date, hasUnreadMessages: Bool) -> Chat {
        let chat = Chat()
        chat.name = name
        chat.message = message
        chat.date = date
        chat.hasUnreadMessages = hasUnreadMessages
        
        return chat
    }
    
    func didFoundUser(userID: String, userName: String?) {
        
    }
    
    func didLostUser(userID: String) {
        
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    
    func failedToStartAdvertising(error: Error) {
        
    }
    
    func didRecieveMessage(text: String, fromUser: String, toUser:String) {
        
    }
}
