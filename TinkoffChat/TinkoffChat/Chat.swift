//
//  Chat.swift
//  TinkoffChat
//
//  Created by Alexander on 27/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class Chat: NSObject {
    
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool = false
    var hasUnreadMessages: Bool = false
    
    var incomingMessages : [Message]?
    var outgoingMessages : [Message]?
}

