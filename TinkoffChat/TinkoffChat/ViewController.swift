//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Alexander on 03/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, ConnectionManagerDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var userinfoText: UITextView!
    @IBOutlet weak var avatarPicture: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textColor: UILabel!
    
    var connectionManager: ConnectionManager?
    
    let alert = UIAlertController(title: "Do something", message: "With this", preferredStyle: .actionSheet)
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        print("\(#function)")
        printAllControllsDescriptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(#function)")
        printAllControllsDescriptions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(#function)")
        printAllControllsDescriptions()
        self.present(alert, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(#function)")
        printAllControllsDescriptions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(#function)")
        printAllControllsDescriptions()
    }
    
    // MARK: - Help methods
    
    func printAllControllsDescriptions() {
        let controlls = [usernameField, userinfoText, saveButton]
        for control in controlls {
            print(control?.description ?? "there isn't decription")
            print("\n")
        }
        print("\n\n")
    }
    
    // MARK: - Actions
    
    @IBAction func saveProfileData(_ sender: UIButton) {
        print("Profile data saved")
    }
    
    @IBAction func changeTextColor (_ sender: UIButton) {
        textColor.textColor = sender.backgroundColor
    }
    
    // MARK: -
    
    func setup() {
        setupDependencies()
        setupGestureRecognizer()
        setupActionSheet()
    }
    
    func setupDependencies() {
        usernameField.delegate = self
        userinfoText.delegate = self
        usernameField.returnKeyType = .done
        connectionManager = ConnectionManager()
        connectionManager?.delegate = self
    }
    
    func setupGestureRecognizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector( dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func setupActionSheet() {
        alert.addAction(UIAlertAction(title: "New photo", style: .default) { action in
            
        })
        
        alert.addAction(UIAlertAction(title: "Select photo", style: .default) { action in
            
        })
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { action in
            
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            
        })
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
