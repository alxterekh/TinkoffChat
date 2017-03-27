//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Alexander on 24/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messagesListTableView: UITableView!
    
    let incomingMessageCellId = "incomingMessage"
    let outcomingMessageCellId = "outcomingMessage"
    
    var chat = Chat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
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
        var numberOfRows = 0
        if let incomingMessages = chat.incomingMessages {
            numberOfRows += incomingMessages.count
        }
        if let outgoingingMessages = chat.outgoingMessages {
            numberOfRows += outgoingingMessages.count
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = (indexPath.row % 2 == 0) ? incomingMessageCellId : outcomingMessageCellId
        let cell = messagesListTableView.dequeueReusableCell(withIdentifier:cellId, for:indexPath) as! MessageCell
        let messages = chat.incomingMessages! + chat.outgoingMessages!
        cell.updateCellForMessage(messages[indexPath.row])
        
        return cell
    }
}


