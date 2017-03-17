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
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var avatarName: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var userinfoText: UITextView!
    @IBOutlet weak var avatarPicture: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    var connectionManager: ConnectionManager?
    
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
    
    // MARK: -
    
    @IBAction func saveProfileData(_ sender: UIButton) {
        print("Profile data saved")
    }
    
    func setup() {
        usernameField.delegate = self
        userinfoText.delegate = self
        usernameField.returnKeyType = .done
        connectionManager = ConnectionManager()
        connectionManager?.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector( dismissKeyboard))
        view.addGestureRecognizer(tap)
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
