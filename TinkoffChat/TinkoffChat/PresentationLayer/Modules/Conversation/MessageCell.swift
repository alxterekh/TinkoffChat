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
    
    var message: Message? {
        didSet {
            messageTextLabel.text = message?.text
            // currentMessage?.markAsRead()
        }
    }
    
    func configure(with message: Message) {
        self.message = message
    }
}
