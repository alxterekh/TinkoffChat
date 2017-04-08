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
    var peerManagers = [PeerManager]()
    weak var delegate: CommunicatorManagerDelegate?

    // MARK: -
    
    override init() {
        super.init()
        setup()
    }
    
    fileprivate func setup() {
        multipeerCommunicator.delegate = self
    }
    
    // MARK: -
    
    func didFoundUser(userID: String, userName: String?) {
        if let peerManager = foundPeerManagerWith(identifier: userID) {
            //peerManager load history
        }
        else {
            let peerManager = PeerManager(with:userID, userName:userName)
            peerManagers.append(peerManager)
            delegate?.updateConversationList()
        }
    }
    
    func foundPeerManagerWith(identifier: String) -> PeerManager? {
        var peerManager: PeerManager?
        if let index = peerManagers.index(where: { $0.identifier == identifier }) {
            peerManager = peerManagers[index]
        }
        
        return peerManager
    }
    
    func removePeerManagerWith(identifier: String) {
        if let index = peerManagers.index(where: { $0.identifier == identifier }) {
            peerManagers.remove(at: index)
            delegate?.updateConversationList()
        }
    }
    
    func didLostUser(userID: String) {
        removePeerManagerWith(identifier: userID)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    
    func failedToStartAdvertising(error: Error) {
        
    }
    
    func didRecieveMessage(text: String, fromUser: String, toUser:String) {
        
    }
}
