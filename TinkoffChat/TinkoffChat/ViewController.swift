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
    @IBOutlet weak var saveProfileByGCDButton: UIButton!
    @IBOutlet weak var saveProfileByOperationButton: UIButton!
    @IBOutlet weak var textColorSampleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var succesSavingDataAlert: UIAlertController = {
        let alert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) {
            [unowned self] action in
            self.performSegue(withIdentifier: "unwindToConversationList", sender: self)
        })
        
        return alert
    }()
    
    lazy var failureSavingDataAlert: UIAlertController = {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) {
            [unowned self] action in
            self.performSegue(withIdentifier: "unwindToConversationList", sender: self)
        })
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) {
            [unowned self] action in
            //repeat saving profile data
            })
        
        return alert
    }()

    lazy var photoPicker : UIImagePickerController = {
       
        return UIImagePickerController()
    }()
    
    lazy var avatarImageActionSheet : UIAlertController = {
     
        return UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    }()
    
    var profile = Profile()
    var dataManager = GCDDataManager()
    
    // MARK: -
    
    override func viewDidLoad() {
        setup()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupDefaultActionSheet()
        super.viewDidAppear(animated)
    }
    
    // MARK: - Actions
    
    @IBAction func saveProfileData(_ sender: UIButton) {
        activityIndicator.startAnimating()
        lockButtons(true)
        dataManager.saveProfileData(profile){
        (succes: Bool) in
            self.activityIndicator.stopAnimating()
            self.lockButtons(succes)
            let alert = succes ? self.succesSavingDataAlert : self.failureSavingDataAlert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func changeTextColor (_ sender: UIButton) {
        if let color = sender.backgroundColor {
            textColorSampleLabel.textColor = color
            profile.textColor = color
            lockButtons(false)
        }
    }
    
    func lockButtons(_ value: Bool) {
        saveProfileByGCDButton.isEnabled = !value
        saveProfileByOperationButton.isEnabled = !value
    }
    
   // MARK: - Initialization
    
    func setup() {
        setupActivityIndicator()
        setupDependencies()
        setupGestureRecognizer()
        lockButtons(true)
        tryToUnloadProfileData()
    }
    
    func tryToUnloadProfileData() {
        activityIndicator.startAnimating()
        dataManager.unloadProfileData() {
            (profileData: Profile?) in
            if let profileData = profileData {
                self.profile = profileData
                self.updateViewForProfile(profileData)
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    func updateViewForProfile(_ profile: Profile) {
        usernameField.text = profile.name
        userinfoText.text = profile.userinfo
        avatarImageView.image = profile.avatarImage
        textColorSampleLabel.textColor = profile.textColor
    }
    
    func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle  = .gray;
    }
    
    func setupDependencies() {
        usernameField.delegate = self
        userinfoText.delegate = self
        photoPicker.delegate = self
        usernameField.returnKeyType = .done
    }
    
    func setupGestureRecognizer() {
        let tapOnEmptySpace = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tapOnEmptySpace)
        
        let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(tapGestureRecognizer:)))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapOnImage)
    }
    
    func setupDefaultActionSheet() {
        avatarImageActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

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
    
    func addDeleteActionToDefaultActionSheet() {
        avatarImageActionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive) {
            [unowned self] action in
            
            self.avatarImageView.image = #imageLiteral(resourceName: "placeholder")
            self.profile.avatarImage = #imageLiteral(resourceName: "placeholder")
            self.lockButtons(false)
            self.setupDefaultActionSheet()
        })
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
        profile.avatarImage = chosenImage
        lockButtons(false)
        dismiss(animated:true, completion: nil)
        addDeleteActionToDefaultActionSheet()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
          profile.name = text
            lockButtons(false)
        }
    }

    // MARK: - UITextViewDelegate
    
    func textViewDidEndEditing(_ textView: UITextView) {
        profile.userinfo = textView.text
        lockButtons(false)
    }
}
