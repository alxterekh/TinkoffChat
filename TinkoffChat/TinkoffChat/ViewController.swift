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
    @IBOutlet weak var avatarPicture: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textColor: UILabel!
    
    let connectionManager = ConnectionManager()
    let avatatImageActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let photoPicker = UIImagePickerController()
    
    // MARK: - Lifecycle
    
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
    
    // MARK: - Actions
    
    @IBAction func saveProfileData(_ sender: UIButton) {
        print("Profile data saved")
    }
    
    @IBAction func changeTextColor (_ sender: UIButton) {
        textColor.textColor = sender.backgroundColor
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
        let tapOnEmptySpace = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapOnEmptySpace)
        
        let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        avatarPicture.isUserInteractionEnabled = true
        avatarPicture.addGestureRecognizer(tapOnImage)
    }
    
    func setupActionSheet() {
        avatatImageActionSheet.addAction(UIAlertAction(title: "New photo", style: .default) { [unowned self] action in
            self.photoPicker.allowsEditing = false
            self.photoPicker.sourceType = UIImagePickerControllerSourceType.camera
            self.photoPicker.cameraCaptureMode = .photo
            self.photoPicker.modalPresentationStyle = .fullScreen
            self.present(self.photoPicker, animated: true)
        })
        
        avatatImageActionSheet.addAction(UIAlertAction(title: "Select photo", style: .default) {[unowned self] action in
            self.photoPicker.allowsEditing = false
            self.photoPicker.sourceType = .photoLibrary
            self.photoPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.photoPicker, animated: true)
        })
        
        avatatImageActionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive) {[unowned self] action in
            self.avatarPicture.image = #imageLiteral(resourceName: "placeholder")
        })
        
        avatatImageActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in })
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        present(avatatImageActionSheet, animated: true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        avatarPicture.image = chosenImage
        //avatarPicture.contentMode = .scaleAspectFit
        dismiss(animated:true, completion: nil)
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
