//
//  ConversationCell.swift
//  TinkoffChat
//
//  Created by Alexander on 24/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit

class ConversationCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    private let defaultBackgroundCellColor: UIColor = .white
    private let hightlightedBackgroundCellColor: UIColor = .yellow
    
    private let defaultDateFormat = "hh:mm"
    private let dateFormatForOldMessages = "dd MMM"
    private let defaultMessagePlaceholder = "No messages yet"
    
    var name: String? {
        didSet {
            if let name = name {
                nameLabel.text = name
            }
        }
    }
    
    var message: String? {
        didSet {
                messageLabel.text = (message != nil) ? message : defaultMessagePlaceholder
        }
    }
    
    var date: Date? {
        didSet {
            if let date = date {
                let formatter = DateFormatter()
                formatter.string(from: date)
                formatter.dateFormat = dateIsTooOld(date) ? dateFormatForOldMessages : defaultDateFormat
                dateLabel.text = "\(date)"
            }
        }
    }
    
    var online: Bool = false {
        didSet {
            self.backgroundColor = (online) ? hightlightedBackgroundCellColor : defaultBackgroundCellColor
        }
    }
    var hasUnreadMessages: Bool = false {
        didSet {
            messageLabel.font = (hasUnreadMessages) ? .boldSystemFont(ofSize: 15.0) : .systemFont(ofSize: 15.0)
        }
    }
    
    func dateIsTooOld(_ date: Date) -> Bool {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.string(from: currentDate)
        formatter.string(from: date)
        formatter.dateFormat = defaultDateFormat
        
        return date < currentDate
    }
}



