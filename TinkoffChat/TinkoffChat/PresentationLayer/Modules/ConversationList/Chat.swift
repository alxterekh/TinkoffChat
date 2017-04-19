//
//  Chat.swift
//  TinkoffChat
//
//  Created by Alexander on 27/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class Chat {
    var online: Bool = true
    private(set) var name: String?
    private(set) var messages = [Message]()

    var message: String? {
        return messages.last?.text
    }
    var date: Date? {
        return messages.last?.date
    }
    var hasUnreadMessages: Bool {
        return messages.filter { $0.isUnread }.count > 0
    }
    
    func appendMessage(_ message: Message) {
        messages.append(message)
    }
    
    func chageChatName(_ name: String) {
        self.name = name
    }
    
    //MARK: - Initialization
    
    init(with name: String?) {
        self.name = name
    }
}

