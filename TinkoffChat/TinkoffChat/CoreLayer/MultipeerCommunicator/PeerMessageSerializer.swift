//
//  PeerMessage.swift
//  TinkoffChat
//
//  Created by Alexander on 08/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class PeerMessageSerializer {

    fileprivate static let messageEventTypeKey = "eventType"
    fileprivate static let messageEventTypeDescription = "TextMessage"
    fileprivate static let messageIdKey = "messageId"
    fileprivate static let messageTextKey = "text"
    
    func serializeMessageWith(text: String) throws -> Data  {
        let message = [PeerMessageSerializer.messageEventTypeKey : PeerMessageSerializer.messageEventTypeDescription,
                       PeerMessageSerializer.messageIdKey : generateMessageId(),
                       PeerMessageSerializer.messageTextKey : text]
        
        return try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
    }
    
    func deserializeMessageFrom(data: Data) throws -> String? {
        let peerMessage =  try JSONSerialization.jsonObject(with: data, options:[] ) as? [String: String]
        
        return peerMessage?[PeerMessageSerializer.messageTextKey]
    }
    
    fileprivate func generateMessageId() -> String {
        return ("\(arc4random_uniform(UINT32_MAX)) + \(Date.timeIntervalSinceReferenceDate) + \(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString())!
    }
}
