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

class ConversationListModel : NSObject, NSFetchedResultsControllerDelegate {
    
    fileprivate let conversationCellId = "conversationCell"
    fileprivate let headerTitles = ["Online", "History"]
    
    fileprivate let tableView: UITableView
    fileprivate let fetchResultsController: NSFetchedResultsController<Conversation>
    fileprivate var communicatorService = ServiceAssembly.communicatorService
    
    init(with tableView: UITableView) {
        self.tableView = tableView
        let fetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        let nameSortDescriptor = NSSortDescriptor(key:#keyPath(Conversation.participant.name), ascending: false)
        let dateSortDescriptor = NSSortDescriptor(key:#keyPath(Conversation.lastMessage.date), ascending: false)
        fetchRequest.sortDescriptors = [dateSortDescriptor, nameSortDescriptor]
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
        self.fetchResultsController.delegate = self
        performFetch()
    }
    
    fileprivate func performFetch() {
        do {
            try self.fetchResultsController.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }
    }
    
    //MARK: -
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            deleteRowsInTableAtIndexPath(indexPath)
        case .insert:
            insetRowsInTableAtIndexPath(newIndexPath)
        case .move:
            deleteRowsInTableAtIndexPath(indexPath)
            insetRowsInTableAtIndexPath(newIndexPath)
        case .update:
            reloadRowsInTableAtIndexPath(indexPath)
        }
    }
    
    fileprivate func deleteRowsInTableAtIndexPath(_ indexPath: IndexPath?) {
        if let indexPath = indexPath {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    fileprivate func insetRowsInTableAtIndexPath(_ indexPath: IndexPath?) {
        if let indexPath = indexPath {
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    fileprivate func reloadRowsInTableAtIndexPath(_ indexPath: IndexPath?) {
        if let indexPath = indexPath {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: 		NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
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
        return numberOfRows(inSection: section) == 0 ? nil : Optional<String>(headerTitles[section])
    }
}

