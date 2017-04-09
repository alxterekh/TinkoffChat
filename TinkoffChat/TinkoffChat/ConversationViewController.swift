//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Alexander on 24/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PeerManagerDelegate, UITextViewDelegate {

    @IBOutlet fileprivate weak var messageTexView: UITextView!
    @IBOutlet fileprivate weak var messagesListTableView: UITableView!
    @IBOutlet fileprivate weak var sendButton: UIButton!
    @IBOutlet fileprivate weak var bottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var textViewTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var textViewBottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var bottomPartHeightConstraint: NSLayoutConstraint!

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
            updateTextViewHeight(for: messageTexView.attributedText)
        }
    }
    
    // MARK: - 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesListTableView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
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
        NotificationCenter.default.addObserver(self, selector: #selector(ConversationViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
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
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomSpaceConstraint.constant = keyboardSize.height
        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: NSNotification) {
        bottomSpaceConstraint.constant = 0
    }
    
    // MARK: -
    
    func updateMessageList() {
        DispatchQueue.main.async { self.messagesListTableView.reloadData() }
    }

    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return calculateNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messages = peerManager!.chat.messages
        let messageIndex = messages.count - indexPath.row - 1
        let message = messages[messageIndex]
        let cellId = (message.isOutcoming) ? outcomingMessageCellId : incomingMessageCellId
        let cell = messagesListTableView.dequeueReusableCell(withIdentifier:cellId, for:indexPath) as! MessageCell
        cell.updateCellForMessage(message)
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        
        return cell
    }
    
     // MARK: -
    
    fileprivate func calculateNumberOfRows() -> Int {
        
        return peerManager!.chat.messages.count
    }
    
     // MARK: -
    
    fileprivate static let maxBottomPartHeight: CGFloat = 120
    fileprivate static let minBottomPartHeight: CGFloat = 42
    fileprivate static let lineHeightDeviation: CGFloat = 2
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let futureText = textView.attributedText.mutableCopy() as? NSMutableAttributedString {
            futureText.replaceCharacters(in: range, with: text)
            updateTextViewHeight(for: futureText)
        }
        
        return true
    }
    
    fileprivate func updateTextViewHeight(for text: NSAttributedString) {
        let size = text.boundingRect(with: CGSize(width: messageTexView.textContainer.size.width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        let totalHeight = textViewTopSpaceConstraint.constant + textViewBottomSpaceConstraint.constant + size.height + messageTexView.textContainerInset.top + messageTexView.textContainerInset.bottom
        var resultingHeight = totalHeight < ConversationViewController.maxBottomPartHeight ? totalHeight : ConversationViewController.maxBottomPartHeight
        resultingHeight = resultingHeight > ConversationViewController.minBottomPartHeight ? resultingHeight : ConversationViewController.minBottomPartHeight
        let heightDiff = fabs(bottomPartHeightConstraint.constant - resultingHeight)
        guard let font = messageTexView.font else { return }
        if heightDiff > font.lineHeight - ConversationViewController.lineHeightDeviation {
            bottomPartHeightConstraint.constant = resultingHeight
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
}


