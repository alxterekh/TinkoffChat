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
    var chat = Chat()
    weak var delegate: CommunicatorManagerDelegate?

    init(with peerManagerId: String, userName:String?) {
        self.identifier = peerManagerId
        chat.name = userName
        super.init()
    }
    
    func recieveMessage(text: String) {
       //chat.messages?.append
    }
    
    func sendMessage(text: String) {
        
    }
    
}
