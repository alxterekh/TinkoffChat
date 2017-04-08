//
//  ChatViewController.swift
//  TinkoffChat
//
//  Created by Alexander on 03/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CommunicatorManagerDelegate {
    
    @IBOutlet fileprivate weak var conversationListTableView: UITableView!
    
    fileprivate let conversationCellId = "conversationCell"
    fileprivate let headersTitles = ["Online"] //"History"
    
    fileprivate let communicatorManager = CommunicatorManager()
    
    @IBAction fileprivate func unwindToConversationList(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate func setup() {
        communicatorManager.delegate = self
        conversationListTableView.dataSource = self
        conversationListTableView.delegate = self
        conversationListTableView.estimatedRowHeight = 44
        conversationListTableView.rowHeight = UITableViewAutomaticDimension
        conversationListTableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        conversationListTableView.reloadData()
    }
    
    // MARK: -
    
    func updateConversationList() {
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
                //vc.peerManager = sender.peerManager
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return headersTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communicatorManager.peerManagers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = conversationListTableView.dequeueReusableCell(withIdentifier:conversationCellId, for:indexPath) as! ConversationCell
        let chat = communicatorManager.peerManagers[indexPath.row].chat
        cell.updateCellForChat(chat)
        
        return cell
    }
}
