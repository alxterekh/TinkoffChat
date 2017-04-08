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
    
    var currentMessage = Message() {
        didSet {
            configureCellWithText(currentMessage.text)
        }
    }
    
    func updateCellForMessage(_ message: Message) {
        currentMessage = message
    }
    
    func configureCellWithText(_ text: String?) {
        if let text = text {
            messageTextLabel.text = text
            messageTextLabel.layer.masksToBounds = true
            messageTextLabel.layer.cornerRadius = 3
        }
    }
}
