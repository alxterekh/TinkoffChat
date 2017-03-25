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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        conversationListTableView.dataSource = self
        conversationListTableView.delegate = self
        conversationListTableView.register(ConversationCell.self, forCellReuseIdentifier: conversationCellId)
        conversationListTableView.estimatedRowHeight = 44
        conversationListTableView.rowHeight = UITableViewAutomaticDimension
        conversationListTableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        conversationListTableView.reloadData()
    }

    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "Conversation", sender: self)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return headersTitles[section]
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "Conversation") {
            var vc = segue.destination as! ConversationViewController
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
        cell.name = "Tinkoff"
        
        return cell
    }
}
