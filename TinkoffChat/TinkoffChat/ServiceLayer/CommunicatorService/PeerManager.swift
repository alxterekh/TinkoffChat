//
//  PeerManager.swift
//  TinkoffChat
//
//  Created by Alexander on 08/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

@objc protocol PeerManagerDelegate : NSObjectProtocol {
    func updateMessageList()
    @objc optional func handleUserStatusChange()
}

func ==(lhs: PeerManagerDelegate, rhs: PeerManagerDelegate) -> Bool {
    return lhs.hash == rhs.hash
}

fileprivate class PeerManagerDelegateWeakWrapper {
    weak var delegate: PeerManagerDelegate?
    
    init(delegate: PeerManagerDelegate) {
        self.delegate = delegate
    }
}

class PeerManager {
    
    let identifier: String
    let chat: Chat
    fileprivate let multipeerCommunicator: Communicator
    fileprivate var delegates = [PeerManagerDelegateWeakWrapper]()
    
    //MARK: -
    
    init(with peerManagerId: String, userName:String?, multipeerCommunicator: Communicator) {
        identifier = peerManagerId
        chat = Chat(with: userName)
        self.multipeerCommunicator = multipeerCommunicator
    }
    
    func addDelegate(_ delegate: PeerManagerDelegate) {
        delegates.append(PeerManagerDelegateWeakWrapper(delegate: delegate))
    }
    
    func removeDelegate(_ delegate: PeerManagerDelegate) {
        let filteredDelegates = delegates.filter {
            if let wrapperDelegate = $0.delegate {
                return !(wrapperDelegate == delegate)
            }
            else {
                return false
            }
        }
        
        delegates = filteredDelegates
    }
    
    func sendMessage(text: String) {
        let message = Message(with: text, date: Date(), isOutcoming: true)
        message.markAsRead()
        chat.appendMessage(message)
        multipeerCommunicator.sendMessage(string: text, to: identifier, completionHandler: nil)
        notifyDelegates()
    }
    
    //MARK: -
    
    func recieveMessage(text: String) {
        let message = Message(with: text, date: Date(), isOutcoming: false)
        chat.appendMessage(message)
        notifyDelegates()
    }
    
    func didLostUser() {
        chat.online = false
        notifyDelegatesAboutUserStatusChanges()
    }
    
    func didFindUser() {
        chat.online = true
        notifyDelegatesAboutUserStatusChanges()
    }
    
    fileprivate func notifyDelegates() {
        DispatchQueue.main.async {
            for wrapper in self.delegates {
                wrapper.delegate?.updateMessageList()
            }
        }
    }
    
    fileprivate func notifyDelegatesAboutUserStatusChanges() {
        DispatchQueue.main.async {
            for wrapper in self.delegates {
                wrapper.delegate?.handleUserStatusChange?()
            }
        }
    }
}
