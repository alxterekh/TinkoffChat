//
//  ConversationListModel.swift
//  TinkoffChat
//
//  Created by Alexander on 08/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ConversationListModel : NSObject {
    
    fileprivate let conversationCellId = "conversationCell"    
    fileprivate let tableView: UITableView
    fileprivate let fetchResultsController: NSFetchedResultsController<Conversation>
    fileprivate var communicatorService = ServiceAssembly.communicatorService
    fileprivate var fetchResultslControllerDelegate: FetchResultslControllerDelegate?
    
    init(with tableView: UITableView) {
        self.tableView = tableView
        let fetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        let sectionSortDescriptor = NSSortDescriptor(key:#keyPath(Conversation.isAbleToConversate), ascending: false)
        let nameSortDescriptor = NSSortDescriptor(key:#keyPath(Conversation.participant.name), ascending: false)
        let dateSortDescriptor = NSSortDescriptor(key:#keyPath(Conversation.lastMessage.date), ascending: false)
        fetchRequest.sortDescriptors = [sectionSortDescriptor, dateSortDescriptor, nameSortDescriptor]
        guard let context = ServiceAssembly.coreDataStack.mainContext else {
            print("No cotext for frc!")
            abort()
        }
        self.fetchResultsController = NSFetchedResultsController<Conversation>(fetchRequest: fetchRequest,
                                                                               managedObjectContext: context,
                                                                               sectionNameKeyPath: #keyPath(Conversation.isAbleToConversate),
                                                                               cacheName: nil)
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        fetchResultslControllerDelegate = FetchResultslControllerDelegate(with: self.tableView)
        self.fetchResultsController.delegate = fetchResultslControllerDelegate
        performFetch()
    }
    
    fileprivate func performFetch() {
        do {
            try self.fetchResultsController.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }
    }
}

extension ConversationListModel: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard  let sectionsCount = fetchResultsController.sections?.count else { return 0 }
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(inSection: section)
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        guard let sections = fetchResultsController.sections?[section] else { return 0 }
        return sections.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:conversationCellId, for:indexPath) as! ConversationCell
        let conversation = fetchResultsController.object(at: indexPath)
        cell.configure(with: conversation)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard numberOfRows(inSection: section) > 0 else {
            return nil
        }
        
        let conversation = fetchResultsController.object(at: IndexPath(row: 0, section: section))
        return conversation.isAbleToConversate ? "Online" : "History"
    }
}

