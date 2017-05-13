//
//  CommunicatorManager.swift
//  TinkoffChat
//
//  Created by Alexander on 07/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

protocol CommunicatorService {
    func updateMyPeerName(_ name: String)
    func sendMessage(text: String, to conversation: Conversation)
}

final class CommunicatorSupervisor : CommunicatorService {
    fileprivate var multipeerCommunicator: Communicator
    fileprivate let conversationStorage: ConversationStorageService
    
    init(with communicator: Communicator, storage: ConversationStorageService) {
        conversationStorage = storage
        multipeerCommunicator = communicator
        multipeerCommunicator.delegate = self
    }

    func updateMyPeerName(_ name: String) {
        multipeerCommunicator.updateMyPeerName(name)
    }
    
    func sendMessage(text: String, to conversation: Conversation) {
        if let participant = conversation.participant,
            let userId = participant.userId {
            multipeerCommunicator.sendMessage(string: text, to: userId) {
                success, error in
                
                if success {
                   self.conversationStorage.handleSentMessage(text: text, to: conversation)
                }
                else {
                   print("\(String(describing: error))")
                }
            }
        }
    }
}

extension CommunicatorSupervisor : MultipeerCommunicatorDelegate {
    
    func didFindUser(userID: String, userName: String?) {
        conversationStorage.handleFoundUser(with: userID, userName: userName)
    }
    
    func didLooseUser(userID: String) {
        conversationStorage.handleLostUser(with: userID)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser:String) {
        conversationStorage.handleReceivedMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print("\(String(describing: error))")
    }
    
    func failedToStartAdvertising(error: Error) {
        print("\(String(describing: error))")
    }
}
