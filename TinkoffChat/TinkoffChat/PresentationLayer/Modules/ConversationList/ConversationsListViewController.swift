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
    fileprivate var conversationListModel: ConversationListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate let estimatedConversationCellRowHeight: CGFloat = 44
    
    fileprivate func setup() {
        tableView.estimatedRowHeight = estimatedConversationCellRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        conversationListModel = ConversationListModel(with: tableView)
    }
    
    fileprivate func handleProfileReadingError(_ error: Error?) {
        if let error = error {
            print("\(error)")
        }
    }
    
    @IBAction fileprivate func unwindToConversationList(segue: UIStoryboardSegue) {
        if let profileEditor = segue.source as? ProfileEditorViewController {
            //communicatorManager.updateMyPeerName(profile.name)
        }
    }
}



