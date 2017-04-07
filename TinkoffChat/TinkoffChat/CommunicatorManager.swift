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

class PeerManager : NSObject {
    
    //chat 
    
    //some methods for updating
    
    //delegate

}

protocol CommunicatorManagerDelegate : class {
    func updateConversationList()
}

class CommunicatorManager: NSObject, CommunicatorDelegate {
    
    fileprivate let multipeerCommunicator = MultipeerCommunicator()
    
    weak var delegate: CommunicatorManagerDelegate?
    var chats = [Chat]()

    // MARK: -
    
    override init() {
        super.init()
        setup()
    }
    
    fileprivate func setup() {
        multipeerCommunicator.delegate = self
    }
    
    func didFoundUser(userID: String, userName: String?) {
        let chat = Chat()
        chat.name = userName
        chats.append(chat)
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
