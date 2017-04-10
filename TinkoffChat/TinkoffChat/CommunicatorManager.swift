//
//  CommunicatorManager.swift
//  TinkoffChat
//
//  Created by Alexander on 07/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

protocol CommunicatorManagerDelegate : class {
    func updateConversationList()
}

class CommunicatorManager: NSObject, CommunicatorDelegate {
    
    fileprivate let multipeerCommunicator = MultipeerCommunicator()
    private(set) var peerManagers = [PeerManager]()
    weak var delegate: CommunicatorManagerDelegate?

    // MARK: -
    
    override init() {
        super.init()
        setup()
    }
    
    fileprivate func setup() {
        multipeerCommunicator.delegate = self
    }
        
    // MARK: - CommunicatorDelegate
    
    func didFoundUser(userID: String, userName: String?) {
        if let peerManager = findPeerManagerWith(identifier: userID) {
            peerManager.didFoundUser()
        }
        else {
            let peerManager = PeerManager(with:userID, userName:userName, multipeerCommunicator: multipeerCommunicator)
            peerManagers.append(peerManager)
        }
        
        delegate?.updateConversationList()
    }
    
    func didLostUser(userID: String) {
        if let peerManager = findPeerManagerWith(identifier: userID) {
            peerManager.didLostUser()
            delegate?.updateConversationList()
        }
    }
    
    fileprivate func findPeerManagerWith(identifier: String) -> PeerManager? {
        var peerManager: PeerManager?
        if let index = peerManagers.index(where: { $0.identifier == identifier }) {
            peerManager = peerManagers[index]
        }
        
        return peerManager
    }
    
    func didRecieveMessage(text: String, fromUser: String, toUser:String) {
        if let peerManager = findPeerManagerWith(identifier: fromUser) {
            peerManager.recieveMessage(text: text)
        }
    }
    
    func getOnlinePeerManagers() -> [PeerManager] {
        
        return peerManagers.filter { return $0.chat.online }
    }
    
    func getOfflinePeerManagers() -> [PeerManager] {
        
        return peerManagers.filter { return !$0.chat.online }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        //error handling
    }
    
    func failedToStartAdvertising(error: Error) {
        //error handling
    }
}
