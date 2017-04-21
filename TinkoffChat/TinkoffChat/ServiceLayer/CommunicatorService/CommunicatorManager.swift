//
//  CommunicatorManager.swift
//  TinkoffChat
//
//  Created by Alexander on 07/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

protocol CommunicatorManagerDelegate : class {
    func updateMessageList()
    //@objc optional func handleUserStatusChange()
    func updateConversationList()
    func handleMultipeerError(_ error: Error)
} 

protocol CommunicatorService {
    weak var delegate: CommunicatorManagerDelegate? { get set }
    func updateMyPeerName(_ name: String)
    func getOnlineChats() -> [Chat]
    func getOfflineChats() -> [Chat]
}

final class CommunicatorManager : CommunicatorService {
    fileprivate var multipeerCommunicator: Communicator
    weak var delegate: CommunicatorManagerDelegate?
    
    fileprivate var chats = [Chat]()
    
    //fileprivate var delegates = [PeerManagerDelegateWeakWrapper]()
    
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
    
//    func addDelegate(_ delegate: PeerManagerDelegate) {
//        delegates.append(PeerManagerDelegateWeakWrapper(delegate: delegate))
//    }
//    
//    func removeDelegate(_ delegate: PeerManagerDelegate) {
//        let filteredDelegates = delegates.filter {
//            if let wrapperDelegate = $0.delegate {
//                return !(wrapperDelegate == delegate)
//            }
//            else {
//                return false
//            }
//        }
//        
//        delegates = filteredDelegates
//    }
    
    func sendMessage(text: String, to chat: Chat) {
        let message = Message(with: text, date: Date(), isOutcoming: true)
        message.markAsRead()
        chat.appendMessage(message)
        multipeerCommunicator.sendMessage(string: text, to: chat.identifier, completionHandler: nil)
        delegate?.updateMessageList()
        
        //notifyDelegates()
    }
    
    // MARK: - FailureHandling
    
    func failedToStartBrowsingForUsers(error: Error) {
        delegate?.handleMultipeerError(error)
    }
    
    func failedToStartAdvertising(error: Error) {
        delegate?.handleMultipeerError(error)
    }
}

extension CommunicatorManager : MultipeerCommunicatorDelegate {
    
    func didFindUser(userID: String, userName: String?) {
        if let chat = findChatWith(identifier: userID) {
            chat.online = true
            //notifyDelegatesAboutUserStatusChanges()
        }
        else {
            let chat = Chat(with: userName, identifier: userID)
            chats.append(chat)
        }
        
        delegate?.updateConversationList()
    }
    
    func didLooseUser(userID: String) {
        if let chat = findChatWith(identifier: userID) {
            chat.online = false
            //notifyDelegatesAboutUserStatusChanges()
            delegate?.updateConversationList()
        }
    }
    
//    fileprivate func notifyDelegatesAboutUserStatusChanges() {
//        DispatchQueue.main.async {
//            for wrapper in self.delegates {
//                wrapper.delegate?.handleUserStatusChange?()
//            }
//        }
//    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser:String) {
        if let chat = findChatWith(identifier: fromUser) {
            let message = Message(with: text, date: Date(), isOutcoming: false)
            chat.appendMessage(message)
            delegate?.updateMessageList()
            
            //notifyDelegates()
        }
    }
    
//    fileprivate func notifyDelegates() {
//        DispatchQueue.main.async {
//            for wrapper in self.delegates {
//                wrapper.delegate?.updateMessageList()
//            }
//        }
//    }
    
    fileprivate func findChatWith(identifier: String) -> Chat? {
        return chats.filter { $0.identifier == identifier }.first
    }
}


//@objc protocol PeerManagerDelegate : NSObjectProtocol {
//    func updateMessageList()
//    @objc optional func handleUserStatusChange()
//}
//
//func ==(lhs: PeerManagerDelegate, rhs: PeerManagerDelegate) -> Bool {
//    return lhs.hash == rhs.hash
//}
//
//fileprivate class PeerManagerDelegateWeakWrapper {
//    weak var delegate: PeerManagerDelegate?
//    
//    init(delegate: PeerManagerDelegate) {
//        self.delegate = delegate
//    }
//}

