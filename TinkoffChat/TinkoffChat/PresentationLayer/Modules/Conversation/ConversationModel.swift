//
//  ConversationModel.swift
//  TinkoffChat
//
//  Created by Alexander on 08/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ConversationModel : NSObject, NSFetchedResultsControllerDelegate {
    
    fileprivate let conversationCellId = "conversationCell"
    fileprivate let incomingMessageCellId = "incomingMessage"
    fileprivate let outcomingMessageCellId = "outcomingMessage"
    
    fileprivate let tableView: UITableView
    fileprivate let fetchResultsController: NSFetchedResultsController<Message>
    
    var communicator: CommunicatorService?

    func sendMessage(text: String) {
        //communicator?.sendMessage(text: text, to: <#T##Conversation#>)
    }
    
    init(with tableView: UITableView) {
        self.tableView = tableView
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:#keyPath(Message.date), ascending: false)]
        self.fetchResultsController = NSFetchedResultsController<Message>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.fetchResultsController.delegate = self
        
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

extension ConversationModel: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard  let sectionsCount = fetchResultsController.sections?.count else { return 0 }
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(inSection: section)
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        guard let sections = fetchResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = fetchResultsController.object(at: indexPath)
        
        //let messageIndex = messages.count - indexPath.row - 1
        //let message = messages[messageIndex]
        //let cellId = (message.isOutcoming) ? outcomingMessageCellId : incomingMessageCellId
        let cell = tableView.dequeueReusableCell(withIdentifier:conversationCellId, for:indexPath) as! MessageCell
       
        //cell.configure(with: message)
        
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        
        return cell
    }
}

    
