//
//  Message.swift
//  TinkoffChat
//
//  Created by Alexander on 27/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class Message: NSObject {
    
    private(set) var text: String?
    private(set) var date: Date?
    private(set) var isOutcoming: Bool = false
    private(set) var isUnread: Bool = true
    
    init(with text: String, date: Date, isOutcoming: Bool) {
        self.text = text
        self.date = date
        self.isOutcoming = isOutcoming
        super.init()
    }
    
    func markAsRead() {
        isUnread = false
    }
}
