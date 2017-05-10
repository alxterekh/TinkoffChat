//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Alexander on 03/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class ProfileEditorViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet fileprivate weak var usernameField: UITextField!
    @IBOutlet fileprivate weak var userinfoText: UITextView!
    @IBOutlet fileprivate weak var avatarImageView: UIImageView!
    @IBOutlet fileprivate weak var saveProfileByGCDButton: UIButton!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate lazy var photoPicker : UIImagePickerController = {
        return UIImagePickerController()
    }()
    
    fileprivate let profileDataService = ServiceAssembly.profileDataService()
    
    fileprivate(set) var profile = Profile.createDefaultProfile() {
        didSet {
            updateView()
        }
    }
    
    // MARK: - Actions
    
    @IBAction fileprivate func saveProfileDataByGCDButtonTap(_ sender: UIButton) {
        saveProfile()
    }
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate func setup() {
        setupDependencies()
        setupGestureRecognizer()
        setDefaultUserNamePlaceholder()
        loadProfileData()
    }
    
    fileprivate func setupDependencies() {
        usernameField.delegate = self
        userinfoText.delegate = self
        photoPicker.delegate = self
    }
    
    fileprivate func setupGestureRecognizer() {
        let tapToDismissKeyboards = UITapGestureRecognizer(target: self, action: #selector(ProfileEditorViewController.dismissKeyboard))
        view.addGestureRecognizer(tapToDismissKeyboards)
        
        let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(ProfileEditorViewController.imageTapped(tapGestureRecognizer:)))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapOnImage)
    }
    
    fileprivate func setDefaultUserNamePlaceholder() {
        usernameField.placeholder = UIDevice.current.name
    }
    
    // MARK: - Alerts
    
    fileprivate func showFailedDataSaveOperationAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) {
            [unowned self] action in
            self.performSegue(withIdentifier: "unwindToConversationList", sender: self)
        })
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) {
            [unowned self] action in
            self.saveProfile()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: -
    
    fileprivate func updateView() {
        usernameField.text = profile.name
        userinfoText.text = profile.userInfo
        avatarImageView.image = profile.userPicture
    }
    
    fileprivate func loadProfileData() {
        activityIndicator.startAnimating()
        profileDataService.loadProfileData() {
            self.activityIndicator.stopAnimating()
            if let profile = $0 {
                self.profile = profile
            }
            else {
                self.profile = Profile.createDefaultProfile()
            }
            
            self.handleDataOperationError($1)
        }
    }
    
    fileprivate func saveProfile() {
        activityIndicator.startAnimating()
        saveProfileByGCDButton.isEnabled = false
        profileDataService.saveProfileData(profile) {
            success, error in
            
            self.activityIndicator.stopAnimating()
            if success {
                self.performSegue(withIdentifier: "unwindToConversationList", sender: self)
            }
            else {
                self.showFailedDataSaveOperationAlert()
            }
            
            self.saveProfileByGCDButton.isEnabled = true
            self.handleDataOperationError(error)
        }
    }
    
    fileprivate func handleDataOperationError(_ error: Error?) {
        if let savingError = error {
            print("\(savingError)")
        }
    }
    
    // MARK: -
    
    @objc fileprivate func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let userPictureActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        addDefaultActionsToSheet(userPictureActionSheet)
        if (!profile.hasDefaultUserPicture()) {
            addDeleteActionToSheet(userPictureActionSheet)
        }
        present(userPictureActionSheet, animated: true)
    }
    
    fileprivate func addDefaultActionsToSheet(_ sheet: UIAlertController) {
        sheet.addAction(UIAlertAction(title: "Take photo", style: .default) {
            [unowned self] action in
            
            self.photoPicker.allowsEditing = false
            self.photoPicker.sourceType = UIImagePickerControllerSourceType.camera
            self.photoPicker.cameraCaptureMode = .photo
            self.photoPicker.modalPresentationStyle = .fullScreen
            self.present(self.photoPicker, animated: true)
        })
        
        sheet.addAction(UIAlertAction(title: "Select from library", style: .default) {
            [unowned self] action in
            
            self.photoPicker.allowsEditing = false
            self.photoPicker.sourceType = .photoLibrary
            self.photoPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.photoPicker, animated: true)
        })
        
        sheet.addAction(UIAlertAction(title: "Load from network", style: .default) {
            [unowned self] action in
            
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserImagePickerViewController") {
                 self.present(vc, animated: true)
            }
        })
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in })
    }
    
    fileprivate func addDeleteActionToSheet(_ sheet: UIAlertController) {
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive) {
            [unowned self] action in
            
            self.avatarImageView.image = #imageLiteral(resourceName: "placeholder")
            self.profile = self.profile.createCopyWithChange(userPicture: #imageLiteral(resourceName: "placeholder"))
        })
    }
    
    @objc fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ProfileEditorViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profile = profile.createCopyWithChange(userPicture: chosenImage)
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileEditorViewController : UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if let text = textView.text {
            profile = profile.createCopyWithChange(userInfo: text)
        }
    }
}

extension ProfileEditorViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            profile = profile.createCopyWithChange(name: text)
        }
    }
}
