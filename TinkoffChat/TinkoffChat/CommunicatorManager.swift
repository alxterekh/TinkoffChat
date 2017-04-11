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
    func handleMultipeerError(_ error: Error)
}

final class CommunicatorManager: NSObject, CommunicatorDelegate {
    
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
    
    func updateMyPeerName(_ name: String) {
        multipeerCommunicator.updateMyPeerName(name)
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
        
        DispatchQueue.main.async { self.delegate?.updateConversationList() }
    }
    
    func didLostUser(userID: String) {
        if let peerManager = findPeerManagerWith(identifier: userID) {
            peerManager.didLostUser()
            DispatchQueue.main.async { self.delegate?.updateConversationList() }
        }
    }
    
    fileprivate func findPeerManagerWith(identifier: String) -> PeerManager? {
        return peerManagers.filter { $0.identifier == identifier }.first
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
        DispatchQueue.main.async { self.delegate?.handleMultipeerError(error) }
    }
    
    func failedToStartAdvertising(error: Error) {
        DispatchQueue.main.async { self.delegate?.handleMultipeerError(error) }
    }
}
