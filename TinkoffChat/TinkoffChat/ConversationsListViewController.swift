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
    
    var setOfChats = [[Chat]]()
    
    @IBAction func unwindToConversationList(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        setOfChats = dataProvider.createSampleDataForConversation()
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
        return setOfChats[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = conversationListTableView.dequeueReusableCell(withIdentifier:conversationCellId, for:indexPath) as! ConversationCell
        
        let chats = setOfChats[indexPath.section]
        let chat = chats[indexPath.row]
        cell.updateCellForChat(chat)
        
        return cell
    }
}
