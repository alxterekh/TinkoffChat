//
//  PeerManager.swift
//  TinkoffChat
//
//  Created by Alexander on 08/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

protocol PeerManagerDelegate : class {
    func updateMessageList()
}

class PeerManager: NSObject {
    
    let identifier: String
    private(set) var chat = Chat()
    weak var delegate: PeerManagerDelegate?

    init(with peerManagerId: String, userName:String?) {
        self.identifier = peerManagerId
        chat.name = userName
        super.init()
    }
    
    func recieveMessage(text: String) {
        let message = Message(with: text, date: Date(), isOutcoming: false)
        chat.messages.append(message)
        delegate?.updateMessageList()
    }
    
    func sendMessage(text: String) {
        let message = Message(with: text, date: Date(), isOutcoming: true)
        chat.messages.append(message)
        delegate?.updateMessageList()
    }
}
