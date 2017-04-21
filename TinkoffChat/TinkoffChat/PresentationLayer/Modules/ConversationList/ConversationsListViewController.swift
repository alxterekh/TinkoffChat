//
//  ChatViewController.swift
//  TinkoffChat
//
//  Created by Alexander on 03/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

final class ConversationsListViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate let conversationCellId = "conversationCell"
    fileprivate let headerTitles = ["Online", "History"]
    
    fileprivate var communicatorManager = ServiceAssembly.communicatorService()
    fileprivate var chats = [[Chat]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate func setup() {
        communicatorManager.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateConversationList()
    }
    
    fileprivate func updateUserName(with profile: Profile?) {
        if let profile = profile {
            communicatorManager.updateMyPeerName(profile.name)
        }
    }
    
    fileprivate func handleProfileReadingError(_ error: Error?) {
        if let error = error {
            print("\(error)")
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Conversation" {
            let vc = segue.destination as! ConversationViewController
            if let sender = sender as? ConversationCell {
                vc.chat = sender.chat
            }
        }
    }
    
    @IBAction fileprivate func unwindToConversationList(segue: UIStoryboardSegue) {
        if let profileEditor = segue.source as? ProfileEditorViewController {
            updateUserName(with: profileEditor.profile)
        }
    }
}

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return numberOfRows(inSection: section) == 0 ? nil : Optional<String>(headerTitles[section])
    }
}

extension ConversationsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(inSection: section)
    }
    
    fileprivate func numberOfRows(inSection section: Int) -> Int {
        return chats[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:conversationCellId, for:indexPath) as! ConversationCell
        let chat = chats[indexPath.section][indexPath.row]
        cell.updateCellForChat(chat)
        
        return cell
    }
}

extension ConversationsListViewController: CommunicatorManagerDelegate {
    func updateConversationList() {
//        peerManagers = [sortPeerManagers(communicatorManager.getOnlinePeerManagers()),
//                        sortPeerManagers(communicatorManager.getOfflinePeerManagers())]
        tableView.reloadData()
    }
    
//    fileprivate func sortPeerManagers(_ peerManagers: [PeerManager]) -> [PeerManager] {
//        let peersWithLastMessageDate = peerManagers.filter { $0.chat.date != nil }
//        let peersWithoutLastMessageDate = peerManagers.filter { $0.chat.date == nil && $0.chat.name != nil }
//        let peersWithoutDateAndName = peerManagers.filter { $0.chat.date == nil && $0.chat.name == nil }
//        
//        let sortedPeersWithLastMessageDate = peersWithLastMessageDate.sorted { $0.chat.date! > $1.chat.date! }
//        let sortedPeersWithoutLastMessageDate = peersWithoutLastMessageDate.sorted { $0.chat.name! > $1.chat.name! }
//        
//        return sortedPeersWithLastMessageDate + sortedPeersWithoutLastMessageDate + peersWithoutDateAndName
//    }
    
    func handleMultipeerError(_ error: Error) {
        print("\(error)")
    }
}
