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
    fileprivate let headersTitles = ["Online", "History"]
    
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
        if self.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return nil
        }
        else {
            return headersTitles[section]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Conversation") {
            let vc = segue.destination as! ConversationViewController
            if let sender = sender as? ConversationCell {
                vc.peerManager = sender.peerManager
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return headersTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let offlinePeerManagersCount = communicatorManager.getOfflinePeerManagers().count
        let onlinePeerManagersCount = communicatorManager.getOnlinePeerManagers().count
        let peerManagersCountCalculatedByStatus = [onlinePeerManagersCount, offlinePeerManagersCount]
        
        return peerManagersCountCalculatedByStatus[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let peerManagersSeparatedByStatus = [communicatorManager.getOnlinePeerManagers(), communicatorManager.getOfflinePeerManagers()]
        let cell = conversationListTableView.dequeueReusableCell(withIdentifier:conversationCellId, for:indexPath) as! ConversationCell
        let neededPeerManagers = peerManagersSeparatedByStatus[indexPath.section]
        let filteredPeerManagers = neededPeerManagers.sorted(by: {
            if ($0.chat.date != nil) && ($1.chat.date != nil) {
               return $0.chat.date! > $1.chat.date!
            }
            else if ($0.chat.date == nil) && ($1.chat.date != nil) {
                return true
            }
            else if ($0.chat.date != nil) && ($1.chat.date == nil) {
                return false
            }
            else {
                return $0.chat.name! > $1.chat.name!
            }})
        let peerManager = filteredPeerManagers[indexPath.row]
        cell.updateCellForPeerManager(peerManager)
        
        return cell
    }
}
