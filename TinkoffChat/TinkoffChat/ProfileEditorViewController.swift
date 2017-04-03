//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Alexander on 03/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class ProfileEditorViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet fileprivate weak var usernameField: UITextField!
    @IBOutlet fileprivate weak var userinfoText: UITextView!
    @IBOutlet fileprivate weak var avatarImageView: UIImageView!
    @IBOutlet fileprivate weak var saveProfileByGCDButton: UIButton!
    @IBOutlet fileprivate weak var saveProfileByOperationButton: UIButton!
    @IBOutlet fileprivate weak var textColorSampleLabel: UILabel!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!

    fileprivate lazy var photoPicker : UIImagePickerController = {
       
        return UIImagePickerController()
    }()
    
    fileprivate var originalProfile = Profile.createDefaultProfile()
    fileprivate var changedProfile = Profile.createDefaultProfile() {
        didSet {
            setButtonsAreEnabled(!(changedProfile == originalProfile))
            updateView()
        }
    }
    
    fileprivate var gcdBasedDataOperator = GCDBasedDataOperator()
    fileprivate var operationBasedDataOperator = OperationBasedDataOperator()
    
    // MARK: - Actions
    
    @IBAction fileprivate func saveProfileDataByGCDButtonTap(_ sender: UIButton) {
        saveProfile(using: gcdBasedDataOperator)
    }
    
    @IBAction fileprivate func saveProfileDataByOperationButtonTap(_ sender: UIButton) {
        saveProfile(using: operationBasedDataOperator)
    }
    
    @IBAction fileprivate func changeTextColor (_ sender: UIButton) {
        if let color = sender.backgroundColor {
            changedProfile = changedProfile.createCopyWithChange(textColor: color)
        }
    }
    
   // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate func setup() {
        setupDependencies()
        setupGestureRecognizer()
        setButtonsAreEnabled(false)
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
    
    // MARK: - Alerts
    
    fileprivate func showSucceesfulDataSaveOperationAlert() {
        let alert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) {
            [unowned self] action in
            self.performSegue(withIdentifier: "unwindToConversationList", sender: self)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func showFailedDataSaveOperationAlert(withDataStore dataStore: DataStore) {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) {
            [unowned self] action in
            self.performSegue(withIdentifier: "unwindToConversationList", sender: self)
        })
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) {
            [unowned self] action in
            self.saveProfile(using: dataStore)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: -
    
    fileprivate func saveProfile(using dataStore: DataStore) {
        activityIndicator.startAnimating()
        setButtonsAreEnabled(false)
        dataStore.saveProfileData(changedProfile) {
            success, error in
            
            self.activityIndicator.stopAnimating()
            if success {
                self.showSucceesfulDataSaveOperationAlert()
                self.originalProfile = self.changedProfile
            }
            else {
                self.showFailedDataSaveOperationAlert(withDataStore: dataStore)
            }
            
            self.setButtonsAreEnabled(true)
            self.handleDataOperationError(error)
        }
    }
    
    fileprivate func loadProfileData() {
        activityIndicator.startAnimating()
        // ¯\_(ツ)_/¯ No recommendations for this case in homework
        getRandomDataStore().loadProfileData() {
            self.activityIndicator.stopAnimating()
            if let profile = $0 {
                self.originalProfile = profile
                self.changedProfile = profile
            }
            else {
                self.changedProfile = Profile.createDefaultProfile()
            }
            
            self.handleDataOperationError($1)
        }
    }
    
    fileprivate func handleDataOperationError(_ error: Error?) {
        if let savingError = error {
            print("\(savingError)")
        }
    }
    
    fileprivate func getRandomDataStore() -> DataStore {
        let dataOperators = [gcdBasedDataOperator, operationBasedDataOperator] as [DataStore]
        return dataOperators[Int(arc4random_uniform(2))]
    }
    
    fileprivate func updateView() {
        usernameField.text = changedProfile.name
        userinfoText.text = changedProfile.userInfo
        avatarImageView.image = changedProfile.userPicture
        textColorSampleLabel.textColor = changedProfile.textColor
    }
    
    fileprivate func setButtonsAreEnabled(_ value: Bool) {
        saveProfileByGCDButton.isEnabled = value
        saveProfileByOperationButton.isEnabled = value
    }
    
    @objc fileprivate func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let userPictureActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        addDefaultActionsToSheet(userPictureActionSheet)
        if (!changedProfile.hasDefaultUserPicture()) {
            addDeleteActionToSheet(userPictureActionSheet)
        }
        present(userPictureActionSheet, animated: true)
    }
    
    fileprivate func addDefaultActionsToSheet(_ sheet: UIAlertController) {
        sheet.addAction(UIAlertAction(title: "New photo", style: .default) {
            [unowned self] action in
            
            self.photoPicker.allowsEditing = false
            self.photoPicker.sourceType = UIImagePickerControllerSourceType.camera
            self.photoPicker.cameraCaptureMode = .photo
            self.photoPicker.modalPresentationStyle = .fullScreen
            self.present(self.photoPicker, animated: true)
        })
        
        sheet.addAction(UIAlertAction(title: "Select photo", style: .default) {
            [unowned self] action in
            
            self.photoPicker.allowsEditing = false
            self.photoPicker.sourceType = .photoLibrary
            self.photoPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.photoPicker, animated: true)
        })
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in })
    }
    
    fileprivate func addDeleteActionToSheet(_ sheet: UIAlertController) {
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive) {
            [unowned self] action in
            
            self.avatarImageView.image = #imageLiteral(resourceName: "placeholder")
            self.changedProfile = self.changedProfile.createCopyWithChange(userPicture: #imageLiteral(resourceName: "placeholder"))
        })
    }
    
    @objc fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        changedProfile = changedProfile.createCopyWithChange(userPicture: chosenImage)
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            changedProfile = changedProfile.createCopyWithChange(name: text)
        }
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let text = textView.text {
            changedProfile = changedProfile.createCopyWithChange(userInfo: text)
        }
    }
}
