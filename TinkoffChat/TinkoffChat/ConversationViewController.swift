//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Alexander on 24/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet fileprivate weak var messagesListTableView: UITableView!
    
    fileprivate let incomingMessageCellId = "incomingMessage"
    fileprivate let outcomingMessageCellId = "outcomingMessage"
    
    var chat = Chat()
    
    // MARK: - 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate func setup() {
        messagesListTableView.dataSource = self
        messagesListTableView.delegate = self
        messagesListTableView.estimatedRowHeight = 44
        messagesListTableView.rowHeight = UITableViewAutomaticDimension
        messagesListTableView.tableFooterView = UIView()
        navigationItem.title = chat.name
    }

    
    override func viewDidAppear(_ animated: Bool) {
        messagesListTableView.reloadData()
    }

    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return calculateNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if let messages = chat.messages {
            let message = messages[indexPath.row]
            let cellId = (message.isOutcoming) ? outcomingMessageCellId : incomingMessageCellId
            cell = messagesListTableView.dequeueReusableCell(withIdentifier:cellId, for:indexPath) as! MessageCell
        }

        return (cell != nil) ? cell! : UITableViewCell()
    }
    
     // MARK: -
    
    fileprivate func calculateNumberOfRows() -> Int {
        var numberOfRows = 0
        if let messages = chat.messages {
            numberOfRows += messages.count
        }
        
        return numberOfRows
    }
}


