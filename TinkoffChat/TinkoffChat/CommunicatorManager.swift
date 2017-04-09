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
        
    // MARK: -
    
    func didFoundUser(userID: String, userName: String?) {
        if let _ = findPeerManagerWith(identifier: userID) {
            //load history
        }
        else {
            let peerManager = PeerManager(with:userID, userName:userName)
            peerManagers.append(peerManager)
        }
        
        delegate?.updateConversationList()
    }
    
    func didLostUser(userID: String) {
        removePeerManagerWith(identifier: userID)
    }
    
    fileprivate func findPeerManagerWith(identifier: String) -> PeerManager? {
        var peerManager: PeerManager?
        if let index = peerManagers.index(where: { $0.identifier == identifier }) {
            peerManager = peerManagers[index]
        }
        
        return peerManager
    }
    
    fileprivate func removePeerManagerWith(identifier: String) {
        if let index = peerManagers.index(where: { $0.identifier == identifier }) {
            peerManagers.remove(at: index)
            delegate?.updateConversationList()
        }
    }
    
    func didRecieveMessage(text: String, fromUser: String, toUser:String) {
        if let peerManager = findPeerManagerWith(identifier: fromUser) {
            peerManager.recieveMessage(text: text)
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        //error handling
    }
    
    func failedToStartAdvertising(error: Error) {
        //error handling
    }
}
