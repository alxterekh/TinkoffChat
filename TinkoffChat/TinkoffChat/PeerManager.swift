//
//  PeerManager.swift
//  TinkoffChat
//
//  Created by Alexander on 08/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

protocol PeerManagerDelegate : NSObjectProtocol {
    func updateMessageList()
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

class PeerManager: NSObject {
    
    let identifier: String
    let chat: Chat
    let multipeerCommunicator: MultipeerCommunicator
    fileprivate var delegates = [PeerManagerDelegateWeakWrapper]()
    
    init(with peerManagerId: String, userName:String?, multipeerCommunicator: MultipeerCommunicator) {
        identifier = peerManagerId
        chat = Chat(with: userName)
        self.multipeerCommunicator = multipeerCommunicator
        super.init()
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
    
    func recieveMessage(text: String) {
        let message = Message(with: text, date: Date(), isOutcoming: false)
        chat.appendMessage(message)
        notifyDelegates()
    }
    
    func sendMessage(text: String) {
        let message = Message(with: text, date: Date(), isOutcoming: true)
        message.markAsRead()
        chat.appendMessage(message)
        multipeerCommunicator.sendMessage(string: text, to: identifier, completionHandler: nil)
        notifyDelegates()
    }
    
    fileprivate func notifyDelegates() {
        DispatchQueue.main.async {
            for wrapper in self.delegates {
                wrapper.delegate?.updateMessageList()
            }
        }
    }
}
