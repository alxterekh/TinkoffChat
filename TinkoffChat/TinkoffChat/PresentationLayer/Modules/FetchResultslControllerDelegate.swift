//
//  FetchResultslControllerDataProvider.swift
//  TinkoffChat
//
//  Created by Alexander on 25/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FetchResultslControllerDelegate : NSObject, NSFetchedResultsControllerDelegate {
    
    fileprivate let tableView: UITableView
    
    init(with tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }

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


