//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Alexander on 03/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ConnectionManagerDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var userinfoText: UITextView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textColorSampleLabel: UILabel!
    
    let connectionManager = ConnectionManager()
    let avatarImageActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let photoPicker = UIImagePickerController()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        print("\(#function)")
        printAllControlsDescriptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(#function)")
        printAllControlsDescriptions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(#function)")
        printAllControlsDescriptions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(#function)")
        printAllControlsDescriptions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(#function)")
        printAllControlsDescriptions()
    }
    
    // MARK: - Help methods
    
    func printAllControlsDescriptions() {
        let controls = [usernameField, userinfoText, saveButton] as [UIView]
        for control in controls {
            print(control.description)
            print("\n")
        }
        print("\n\n")
    }
    
    
    // MARK: - Actions
    
    @IBAction func saveProfileData(_ sender: UIButton) {
        print("Profile data saved")
    }
    
    @IBAction func changeTextColor (_ sender: UIButton) {
        textColorSampleLabel.textColor = sender.backgroundColor
    }
    
   // MARK: - Initialization
    
    func setup() {
        setupDependencies()
        setupGestureRecognizer()
        setupActionSheet()
    }
    
    func setupDependencies() {
        usernameField.delegate = self
        userinfoText.delegate = self
        photoPicker.delegate = self
        connectionManager.delegate = self
        usernameField.returnKeyType = .done
    }
    
    func setupGestureRecognizer() {
        let tapOnEmptySpace = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tapOnEmptySpace)
        
        let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(tapGestureRecognizer:)))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapOnImage)
    }
    
    func setupActionSheet() {
        avatarImageActionSheet.addAction(UIAlertAction(title: "New photo", style: .default) {
            [unowned self] action in
            
            self.photoPicker.allowsEditing = false
            self.photoPicker.sourceType = UIImagePickerControllerSourceType.camera
            self.photoPicker.cameraCaptureMode = .photo
            self.photoPicker.modalPresentationStyle = .fullScreen
            self.present(self.photoPicker, animated: true)
        })
        
        avatarImageActionSheet.addAction(UIAlertAction(title: "Select photo", style: .default) {
            [unowned self] action in
            
            self.photoPicker.allowsEditing = false
            self.photoPicker.sourceType = .photoLibrary
            self.photoPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.photoPicker, animated: true)
        })
        
        avatarImageActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in })
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        present(avatarImageActionSheet, animated: true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        avatarImageView.image = chosenImage
        dismiss(animated:true, completion: nil)
        
        avatarImageActionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive) {
            [unowned self] action in
            
            self.avatarImageView.image = #imageLiteral(resourceName: "placeholder")
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
