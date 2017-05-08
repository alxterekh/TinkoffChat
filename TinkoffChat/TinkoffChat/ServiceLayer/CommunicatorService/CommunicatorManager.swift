//
//  CommunicatorManager.swift
//  TinkoffChat
//
//  Created by Alexander on 07/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

protocol CommunicatorService {
    //weak var delegate: CommunicatorManagerDelegate? { get set }
    func updateMyPeerName(_ name: String)
    func sendMessage(text: String, to chat: Chat)
}

final class CommunicatorManager : CommunicatorService {
    
    fileprivate var multipeerCommunicator: Communicator
    //weak var delegate: CommunicatorManagerDelegate?
    
    let conversationsListDataStorageService = ConversationsListDataStorageService()
    
    //MARK: - Initialization
    
    init(with communicator: Communicator) {
        multipeerCommunicator = communicator
        multipeerCommunicator.delegate = self
    }
    
    //MARK: -
    
    func updateMyPeerName(_ name: String) {
        multipeerCommunicator.updateMyPeerName(name)
    }
    
    func sendMessage(text: String, to chat: Chat) {
        //multipeerCommunicator.sendMessage(string: text, to: chat.identifier, completionHandler: nil)
    }
}

extension CommunicatorManager : MultipeerCommunicatorDelegate {
    
    func didFindUser(userID: String, userName: String?) {
        //online = true
        conversationsListDataStorageService.addConversation(with: userID)
    }
    
    func didLooseUser(userID: String) {
        //online = false
        conversationsListDataStorageService.addConversation(with: userID)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser:String) {
//        if let chat = findChatWith(identifier: fromUser) {
////            let message = Message(with: text, date: Date(), isOutcoming: false)
////            chat.appendMessage(message)
//            delegate?.updateView()
//        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print("\(error)")
    }
    
    func failedToStartAdvertising(error: Error) {
        print("\(error)")
    }
}
