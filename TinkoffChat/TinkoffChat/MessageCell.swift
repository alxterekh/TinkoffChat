//
//  MessageCell.swift
//  TinkoffChat
//
//  Created by Alexander on 24/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit
import QuartzCore

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageTextLabel: UILabel!
    
    var currentMessage: Message? {
        didSet {
            messageTextLabel.text = currentMessage?.text
            currentMessage?.markAsRead()
        }
    }
    
    func updateCellForMessage(_ message: Message) {
        currentMessage = message
    }
    
}
