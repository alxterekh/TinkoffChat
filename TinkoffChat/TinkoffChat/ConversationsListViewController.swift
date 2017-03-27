//
//  ChatViewController.swift
//  TinkoffChat
//
//  Created by Alexander on 03/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var conversationListTableView: UITableView!
    
    let conversationCellId = "conversationCell"
    let headersTitles = ["Online","History"]
    
    let dataProvider = DataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        conversationListTableView.dataSource = self
        conversationListTableView.delegate = self
        conversationListTableView.estimatedRowHeight = 44
        conversationListTableView.rowHeight = UITableViewAutomaticDimension
        conversationListTableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        conversationListTableView.reloadData()
    }

    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return headersTitles[section]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Conversation") {
            let vc = segue.destination as! ConversationViewController
            if let sender = sender as? ConversationCell {
                vc.chat = sender.currentChat
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return headersTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = conversationListTableView.dequeueReusableCell(withIdentifier:conversationCellId, for:indexPath) as! ConversationCell
        
        let chat = Chat()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        chat.name = "Tinkoff1"
        chat.message = "No messages"
        chat.date = yesterday
        chat.online = true
        chat.hasUnreadMessages = true
        chat.incomingMessages = createMessagesSampleData()
        chat.outgoingMessages = createMessagesSampleData()
        
        cell.updateCellForChat(chat)
        
        return cell
    }
    
    func createMessagesSampleData() -> [Message] {
        let firstMessage = Message()
        firstMessage.text = "L"
        let secondMessage = Message()
        secondMessage.text = "Lorem ipsum dolor sit amet, pe"
        let thirdMessage = Message()
        thirdMessage.text = "Lorem ipsum dolor sit amet, persecuti dissentias persequeris ut ius. Iudico evertitur accommodare usu ex, vel at atqui facer. Ferri adversarium ad quo, no cum similique constituam. Exerci intellegat reprimique an vel, est ei impetus sanctus vulputate, praesent scripserit liberavisse mel an. Est salu"
        
        return [firstMessage, secondMessage, thirdMessage] as [Message]
    }

}
