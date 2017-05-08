//
//  MessagesDataProvider.swift
//  TinkoffChat
//
//  Created by Alexander on 07/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MuMessage: NSObject {
    
    private(set) var text: String?
    private(set) var date: Date?
    private(set) var isOutcoming: Bool = false
    private(set) var isUnread: Bool = true
    
    init(with text: String, date: Date, isOutcoming: Bool) {
        self.text = text
        self.date = date
        self.isOutcoming = isOutcoming
        super.init()
    }
    
    func markAsRead() {
        isUnread = false
    }
}


class MessagesDataProvider {
    
//    let fetchResultsController: NSFetchedResultsController<Message>
//    let tableView: UITableView
//    
//    init(with tableView: UITableView) {
//        self.tableView = tableView
//        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        let fetchRequest = NSFetchRequest(entityName: "Message")
//        self.fetchResultsController = NSFetchedResultsController<Message>(fetchRequest: fetchRequest, manajedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        fetchResultsController.delegate = self
//    }
//}
//
//extension MessagesDataProvider : NSFetchedResultsControllerDelegate {
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }
//    
//    //refactor
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .delete:
//            if let indexPath = indexPath { tableView.deleteRows(at: [indexPath], with: .automatic)}
//        case .insert:
//            if let newIndexPath = newIndexPath { tableView.insertRows(at: [newIndexPath], with: .automatic)}
//        case .move:
//            if let indexPath = indexPath { tableView.deleteRows(at: [indexPath], with: .automatic)}
//            
//            if let newIndexPath = newIndexPath { tableView.insertRows(at: [newIndexPath], with: .automatic)}
//        case .update:
//            if let indexPath = indexPath { tableView.reloadRows(at: [indexPath], with: .automatic)}
//    
//        }
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: 		NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        switch type {
//        case .delete:
//            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
//        case .insert:
//            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
//        default:
//            break
//        }
//    }
}
