//
//  CommunicatorManager.swift
//  TinkoffChat
//
//  Created by Alexander on 07/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

protocol CommunicatorManagerDelegate : class {
    func updateView()
}

protocol CommunicatorService {
    weak var delegate: CommunicatorManagerDelegate? { get set }
    func updateMyPeerName(_ name: String)
    func getOnlineChats() -> [Chat]
    func getOfflineChats() -> [Chat]
    func sendMessage(text: String, to chat: Chat) 
}

final class CommunicatorManager : CommunicatorService {
    fileprivate var multipeerCommunicator: Communicator
    weak var delegate: CommunicatorManagerDelegate?
    
    fileprivate var chats = [Chat]()
    
    //MARK: - Initialization
    
    init(with communicator: Communicator) {
        multipeerCommunicator = communicator
        multipeerCommunicator.delegate = self
    }
    
    //MARK: -
    
    func updateMyPeerName(_ name: String) {
        multipeerCommunicator.updateMyPeerName(name)
    }
    
    func getOnlineChats() -> [Chat] {
        return chats.filter { return $0.online }
    }
    
    func getOfflineChats() -> [Chat] {
        return chats.filter { return !$0.online }
    }
    
    func sendMessage(text: String, to chat: Chat) {
        let message = Message(with: text, date: Date(), isOutcoming: true)
        message.markAsRead()
        chat.appendMessage(message)
        multipeerCommunicator.sendMessage(string: text, to: chat.identifier, completionHandler: nil)
        delegate?.updateView()
    }
}

extension CommunicatorManager : MultipeerCommunicatorDelegate {
    
    func didFindUser(userID: String, userName: String?) {
        if let chat = findChatWith(identifier: userID) {
            chat.online = true
        }
        else {
            let chat = Chat(with: userName, identifier: userID)
            chats.append(chat)
        }
        
        delegate?.updateView()
    }
    
    func didLooseUser(userID: String) {
        if let chat = findChatWith(identifier: userID) {
            chat.online = false
            delegate?.updateView()
        }
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser:String) {
        if let chat = findChatWith(identifier: fromUser) {
            let message = Message(with: text, date: Date(), isOutcoming: false)
            chat.appendMessage(message)
            delegate?.updateView()
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print("\(error)")
    }
    
    func failedToStartAdvertising(error: Error) {
        print("\(error)")
    }
    
    fileprivate func findChatWith(identifier: String) -> Chat? {
        return chats.filter { $0.identifier == identifier }.first
    }
}
