//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Alexander on 24/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PeerManagerDelegate {

    @IBOutlet fileprivate weak var messageTexView: UITextView!
    @IBOutlet fileprivate weak var messagesListTableView: UITableView!
    @IBOutlet fileprivate weak var sendButton: UIButton!
    
    fileprivate let incomingMessageCellId = "incomingMessage"
    fileprivate let outcomingMessageCellId = "outcomingMessage"
    
    var peerManager: PeerManager? {
        didSet {
            peerManager?.delegate = self
        }
    }
    
    @IBAction fileprivate func sendMessage(_ sender: UIButton) {
        if let peerManager = peerManager {
            peerManager.sendMessage(text: messageTexView.text)
            messageTexView.text = ""
        }
    }
    
    // MARK: - 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messagesListTableView.reloadData()
    }
    
    deinit {
        unsubscribeFromKeyboardNotification()
    }
    
    fileprivate func setup() {
        messagesListTableView.dataSource = self
        messagesListTableView.delegate = self
        messagesListTableView.estimatedRowHeight = 44
        messagesListTableView.rowHeight = UITableViewAutomaticDimension
        messagesListTableView.tableFooterView = UIView()
        subscribeForKeyboardNotification()
        setupGestureRecognizer()
        
        if let peerManager = peerManager {
           navigationItem.title = peerManager.chat.name
        }
    }
    
    fileprivate func subscribeForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(ConversationViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ConversationViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func unsubscribeFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func setupGestureRecognizer() {
        let tapToDismissKeyboards = UITapGestureRecognizer(target: self, action: #selector(ConversationViewController.dismissKeyboard))
        view.addGestureRecognizer(tapToDismissKeyboards)
    }
    
    @objc fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    // MARK: -
    
    func updateMessageList() {
       messagesListTableView.reloadData()
    }

    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return calculateNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        let messages = peerManager!.chat.messages
        let message = messages[indexPath.row]
        let cellId = (message.isOutcoming) ? outcomingMessageCellId : incomingMessageCellId
        cell = messagesListTableView.dequeueReusableCell(withIdentifier:cellId, for:indexPath) as! MessageCell
        
        return (cell != nil) ? cell! : UITableViewCell()
    }
    
     // MARK: -
    
    fileprivate func calculateNumberOfRows() -> Int {
        
        return peerManager!.chat.messages.count
    }
}


