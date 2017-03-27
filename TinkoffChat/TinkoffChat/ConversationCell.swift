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
    private let hightlightedBackgroundCellColor: UIColor = UIColor(red: 1, green: 247/255, blue: 200/255, alpha: 0.6)
    
    private let defaultDateFormat = "hh:mm"
    private let dateFormatForOldMessages = "dd MMM"
    private let defaultMessagePlaceholder = "No messages yet"
    
    private let defaultFont = UIFont.systemFont(ofSize: 17.0)
    private let boldDefaultFont = UIFont.boldSystemFont(ofSize: 17.0)
    private let alertFont = UIFont(name: "Arial", size: 13.0)
    
    var currentChat = Chat() {
        didSet {
            configureCellWithName(currentChat.name)
            configureCellWithDate(currentChat.date)
            configureCellWithOnlineStatus(currentChat.online)
            configureCellWithMessage(currentChat.message)
        }
    }
    
    // MARK: - Cell configuration
    
    func updateCellForChat(_ chat: Chat) {
        currentChat = chat
    }
    
    func configureCellWithName(_ name: String?) {
        if let name = name {
            nameLabel.text = name
        }
    }
    
    func configureCellWithMessage(_ message: String?) {
        messageLabel.text = (message != nil) ? message : defaultMessagePlaceholder
        setupMessageFontIfThereIsUnreadMessages(currentChat.hasUnreadMessages)
    }
    
    func configureCellWithDate(_ date: Date?) {
        if let date = date {
            let formatter = DateFormatter()
            formatter.string(from: date)
            formatter.dateFormat = dateIsTooOld(date) ? dateFormatForOldMessages : defaultDateFormat
            dateLabel.text = formatter.string(from: date)
        }
    }
    
    func configureCellWithOnlineStatus(_ online: Bool) {
        self.backgroundColor = (online) ? hightlightedBackgroundCellColor : defaultBackgroundCellColor
    }
    
    func setupMessageFontIfThereIsUnreadMessages(_ hasUnreadMessages: Bool) {
        if currentChat.message != nil {
            messageLabel.font = (hasUnreadMessages) ? boldDefaultFont : defaultFont
        }
        else {
            messageLabel.font = alertFont
        }
    }
    
    func dateIsTooOld(_ date: Date) -> Bool {
        let startOfDay = Calendar.current.startOfDay(for: Date())
    
        return date.timeIntervalSince1970 < startOfDay.timeIntervalSince1970
    }
}

