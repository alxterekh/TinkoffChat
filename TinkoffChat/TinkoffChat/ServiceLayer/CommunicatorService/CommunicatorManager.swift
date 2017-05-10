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
    var coreDataStack: CoreDataStack { get }
}

final class CommunicatorManager : CommunicatorService {
    fileprivate var multipeerCommunicator: Communicator
    var coreDataStack = CoreDataStack()
    let conversationStorageService: ConversationStorageService
    
    init(with communicator: Communicator) {
        conversationStorageService = ConversationStorageService(with: coreDataStack)
        multipeerCommunicator = communicator
        multipeerCommunicator.delegate = self
    }

    func updateMyPeerName(_ name: String) {
        multipeerCommunicator.updateMyPeerName(name)
    }
    
    func sendMessage(text: String, to conversation: Conversation) {
        if let participant = conversation.participant{
                multipeerCommunicator.sendMessage(string: text, to: participant.userId!, completionHandler: nil)
        }
    }
}

extension CommunicatorManager : MultipeerCommunicatorDelegate {
    
    func didFindUser(userID: String, userName: String?) {
        conversationStorageService.handleFoundUser(with: userID, userName: userName)
    }
    
    func didLooseUser(userID: String) {
        conversationStorageService.handleLostUser(with: userID)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser:String) {
        conversationStorageService.receiveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print("\(error)")
    }
    
    func failedToStartAdvertising(error: Error) {
        print("\(error)")
    }
}
