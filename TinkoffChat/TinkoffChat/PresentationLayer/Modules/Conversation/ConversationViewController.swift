//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Alexander on 24/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, ConversationModelDelegate {
    
    @IBOutlet fileprivate weak var messageTexView: UITextView!
    @IBOutlet fileprivate weak var messagesListTableView: UITableView!
    @IBOutlet fileprivate weak var sendButton: SendMessageButton!
    @IBOutlet fileprivate weak var bottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var textViewTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var textViewBottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var bottomPartHeightConstraint: NSLayoutConstraint!
    
    fileprivate var conversationModel: ConversationModel?
    var conversationIdentifier: String?
    
    @IBAction fileprivate func sendMessage(_ sender: UIButton) {
        messageTexView.text = messageTexView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        conversationModel?.sendMessage(text: messageTexView.text)
        messageTexView.text = ""
        updateTextViewHeight(for: messageTexView.attributedText)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesListTableView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messagesListTableView.reloadData()
        handleChangingConversationState()
    }
    
    deinit {
        unsubscribeFromKeyboardNotification()
    }
    
    fileprivate func setup() {
        setupTableViewProperties()
        subscribeForKeyboardNotification()
        setupGestureRecognizer()
        conversationModel = ConversationModel(with: messagesListTableView, id: conversationIdentifier)
        conversationModel?.delegate = self
        messageTexView.text = ""
        if let name = conversationModel?.conversationName {
            updateHeaderWithName(name)
        }
    }
    
    func handleChangingConversationState() {
        animateHeaderIfNeeded()
        changeSendButtonStateIfNeeded()
    }
    
    fileprivate func animateHeaderIfNeeded() {
        guard let conversationModel = conversationModel else {
            print("No conversation model!")
            return
        }
        
        if conversationModel.conversationIsAbleToConversate {
            animateAppearanceUser()
        }
        else {
            animateDisappearanceUser()
        }
    }
    
    fileprivate func changeSendButtonStateIfNeeded() {
        guard let conversationModel = conversationModel else {
            print("No conversation model!")
            return
        }
        
        let text = messageTexView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if conversationModel.conversationIsAbleToConversate && text != "" {
            sendButton.activate()
        }
        else {
            sendButton.deactivate()
        }
    }
    
    fileprivate let estimatedMessageCellRowHeight: CGFloat = 44
    
    fileprivate func setupTableViewProperties() {
        messagesListTableView.delegate = self
        messagesListTableView.estimatedRowHeight = estimatedMessageCellRowHeight
        messagesListTableView.rowHeight = UITableViewAutomaticDimension
        messagesListTableView.tableFooterView = UIView()
        messagesListTableView.showsVerticalScrollIndicator = false
    }
    
    fileprivate func updateHeaderWithName(_ name: String) {
        let headerLabel = UILabel()
        headerLabel.text = name
        self.navigationItem.titleView = headerLabel
        self.navigationItem.titleView?.sizeToFit()
    }
    
    // MARK: - Animations
    
    fileprivate let duration: TimeInterval = 0.5
    fileprivate let headerScale: CGFloat = 1.10
    
    fileprivate func animateAppearanceUser() {
        UIView.animate(withDuration: duration) {
            self.navigationItem.titleView?.transform = CGAffineTransform(scaleX: self.headerScale, y: self.headerScale)
        }
        animateHeaderTextColorTransition(with: UIColor.black )
    }
    
    fileprivate func animateDisappearanceUser() {
        UIView.animate(withDuration: duration) {
            self.navigationItem.titleView?.transform = CGAffineTransform.identity
        }
        animateHeaderTextColorTransition(with: UIColor.gray)
    }
    
    fileprivate func animateHeaderTextColorTransition(with color: UIColor) {
        let headerLablel = self.navigationItem.titleView as! UILabel
        UIView.transition(with: headerLablel,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: { headerLablel.textColor = color },
                          completion: nil)
    }
    
    // MARK: -
    
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
}

extension ConversationViewController : UITextViewDelegate {
    fileprivate static let maxBottomPartHeight: CGFloat = 120
    fileprivate static let minBottomPartHeight: CGFloat = 42
    fileprivate static let lineHeightDeviation: CGFloat = 2
    fileprivate static let maxMessageLength = 140
    
    func textViewDidChange(_ textView: UITextView) {
        changeSendButtonStateIfNeeded()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let futureText = textView.attributedText.mutableCopy() as? NSMutableAttributedString {
            futureText.replaceCharacters(in: range, with: text)
            updateTextViewHeight(for: futureText)
            return futureText.length < ConversationViewController.maxMessageLength
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

