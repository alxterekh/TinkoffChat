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

protocol IConversationModel {
    func sendMessage(text: String)
}

protocol ConversationModelDelegate : class {
    func handleChangingConversationState()
}

class ConversationModel : NSObject, NSFetchedResultsControllerDelegate {
    fileprivate let incomingMessageCellId = "incomingMessage"
    fileprivate let outcomingMessageCellId = "outcomingMessage"
    fileprivate let tableView: UITableView
    fileprivate let fetchResultsController: NSFetchedResultsController<Message>
    fileprivate let communicator: CommunicatorService = ServiceAssembly.communicatorService
    fileprivate var fetchResultslControllerDelegate: FetchResultslControllerDelegate?
    fileprivate var conversation: Conversation?
    
    weak var delegate: ConversationModelDelegate?
    
    var conversationName: String? {
        get { return conversation?.name}
    }
    
    var conversationIsAbleToConversate: Bool {
        get { return conversation?.isAbleToConversate ?? false }
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
        fetchResultslControllerDelegate = FetchResultslControllerDelegate(with: self.tableView)
        fetchResultsController.delegate = fetchResultslControllerDelegate
        if let conversation = Conversation.performConversationFetchRequest(identifier: id, in: context) {
            self.conversation = conversation
           // delegate?.handleChangingConversationState()
        }
        
        subscribeForCoreDataNotificationsInContext(context)
        performFetch()
        
    }
    
    fileprivate func subscribeForCoreDataNotificationsInContext(_ context: NSManagedObjectContext) {
         let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextDidSave, object: context)
    }
    
    func managedObjectContextObjectsDidChange(notification: NSNotification) {
        
    }
    
    fileprivate func performFetch() {
        do {
            try self.fetchResultsController.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }
    }
    
    func sendMessage(text: String) {
        if let conversation = conversation {
            communicator.sendMessage(text: text, to: conversation)
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

    
