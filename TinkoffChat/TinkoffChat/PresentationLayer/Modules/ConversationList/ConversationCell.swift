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
    
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var messageLabel: UILabel!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    
    fileprivate let defaultBackgroundCellColor: UIColor = .white
    fileprivate let hightlightedBackgroundCellColor: UIColor = UIColor(red: 1, green: 247/255, blue: 200/255, alpha: 0.6)
    
    fileprivate let defaultDateFormat = "hh:mm"
    fileprivate let dateFormatForOldMessages = "dd MMM"
    fileprivate let defaultMessagePlaceholder = "No messages yet"
    
    fileprivate let defaultFont = UIFont.systemFont(ofSize: 17.0)
    fileprivate let boldDefaultFont = UIFont.boldSystemFont(ofSize: 17.0)
    fileprivate let alertFont = UIFont(name: "Arial", size: 13.0)
    
    var conversation: Conversation?
    
    func configure(with conversation: Conversation) {
        self.conversation = conversation
        configureCellWithName(conversation.name)
        configureCellWithOnlineStatus(conversation.isAbleToConversate)
        configureCellWithDate(conversation.lastMessage?.date as Date?)
        configureCellWithMessage(conversation.lastMessage?.text)
    }
    
    fileprivate func configureCellWithName(_ name: String?) {
        if let name = name {
            nameLabel.text = name
        }
    }
    
    fileprivate func configureCellWithMessage(_ message: String?) {
        messageLabel.text = (message != nil) ? message : defaultMessagePlaceholder
        setupMessageFontIfThereIsUnreadMessages(conversation?.hasUnreadMessages() ?? false)
    }
    
    fileprivate func configureCellWithDate(_ date: Date?) {
        if let date = date {
            let formatter = DateFormatter()
            formatter.string(from: date)
            formatter.dateFormat = dateIsTooOld(date) ? dateFormatForOldMessages : defaultDateFormat
            dateLabel.text = formatter.string(from: date)
        }
        else {
            dateLabel.text = ""
        }
    }
    
    fileprivate func configureCellWithOnlineStatus(_ online: Bool) {
        self.backgroundColor = (online) ? hightlightedBackgroundCellColor : defaultBackgroundCellColor
    }
    
    fileprivate func setupMessageFontIfThereIsUnreadMessages(_ hasUnreadMessages: Bool) {
        let messagesCount = conversation?.messages?.count ?? 0
        if messagesCount > 0 {
            messageLabel.font = (hasUnreadMessages) ? boldDefaultFont : defaultFont
        }
        else {
            messageLabel.font = alertFont
        }
    }
    
    fileprivate func dateIsTooOld(_ date: Date) -> Bool {
        let startOfDay = Calendar.current.startOfDay(for: Date())
    
        return date.timeIntervalSince1970 < startOfDay.timeIntervalSince1970
    }
}
