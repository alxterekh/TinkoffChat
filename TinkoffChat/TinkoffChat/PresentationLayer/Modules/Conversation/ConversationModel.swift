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
    
    fileprivate let incomingMessageCellId = "incomingMessage"
    fileprivate let outcomingMessageCellId = "outcomingMessage"
    
    fileprivate let tableView: UITableView
    fileprivate let fetchResultsController: NSFetchedResultsController<Message>
    
    var communicator: CommunicatorService = ServiceAssembly.communicatorService

    func sendMessage(text: String, to conversation: Conversation) {
       communicator.sendMessage(text: text, to: conversation)
    }
    
    init(with tableView: UITableView, id: String?) {
        self.tableView = tableView
        guard let context = ServiceAssembly.coreDataStack.mainContext else {
            print("No cotext for frc!")
            abort()
        }
        
        guard let id = id,
            let fetchRequest: NSFetchRequest<Message> = Message.fetchRequestMessage(in: context, identifier: id) else {
            print("No fetchRequest for frc!")
            abort()
        }

        fetchRequest.sortDescriptors = [NSSortDescriptor(key:#keyPath(Message.date), ascending: false)]
        self.fetchResultsController = NSFetchedResultsController<Message>(fetchRequest: fetchRequest,
                                                                          managedObjectContext: context,
                                                                          sectionNameKeyPath: nil,
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
        let cellId = (message.isOutgoing) ? outcomingMessageCellId : incomingMessageCellId
        let cell = tableView.dequeueReusableCell(withIdentifier:cellId, for:indexPath) as! MessageCell
        cell.configure(with: message)
        cell.selectionStyle = .none
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        
        if message.isUnread,
            let saveContext = ServiceAssembly.coreDataStack.saveContext,
            let messageOnSaveContext = saveContext.object(with: message.objectID) as? Message {
                
                messageOnSaveContext.isUnread = false
                ServiceAssembly.coreDataStack.performSave(context: saveContext) {
                    _, _ in
                }
        }
        
        return cell
    }
}

    
