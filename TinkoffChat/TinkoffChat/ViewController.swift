//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Alexander on 03/03/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var userinfoText: UITextView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var saveProfileByGCDButton: UIButton!
    @IBOutlet weak var saveProfileByOperationButton: UIButton!
    @IBOutlet weak var textColorSampleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    fileprivate lazy var photoPicker : UIImagePickerController = {
       
        return UIImagePickerController()
    }()
    
    fileprivate var originalProfile = Profile.createDefaultProfile()
    fileprivate var changedProfile = Profile.createDefaultProfile() {
        didSet {
            setButtonsAreEnabled(!(changedProfile == originalProfile))
        }
    }
    
    fileprivate var gcdBasedDataOperator = GCDBasedDataOperator()
    fileprivate var operationBasedDataOperator = OperationBasedDataOperator()
    
    // MARK: - Actions
    
    @IBAction func saveProfileDataByGCDButtonTap(_ sender: UIButton) {
        saveProfile(using: gcdBasedDataOperator)
    }
    
    @IBAction func saveProfileDataByOperationButtonTap(_ sender: UIButton) {
        saveProfile(using: operationBasedDataOperator)
    }
    
    @IBAction func changeTextColor (_ sender: UIButton) {
        if let color = sender.backgroundColor {
            textColorSampleLabel.textColor = color
            changedProfile = changedProfile.createCopyWithChange(textColor: color)
        }
    }
    
   // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        setupDependencies()
        setupGestureRecognizer()
        setButtonsAreEnabled(false)
        loadProfileData()
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
    
    // MARK: - Alerts
    
    fileprivate func showSucceesfulDataSaveOperationAlert() {
        let alert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) {
            [unowned self] action in
            self.performSegue(withIdentifier: "unwindToConversationList", sender: self)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func showFailedDataSaveOperationAlert(withDataManager dataManager: DataOperator) {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) {
            [unowned self] action in
            self.performSegue(withIdentifier: "unwindToConversationList", sender: self)
        })
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) {
            [unowned self] action in
            self.saveProfile(using: dataManager)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: -
    
    func saveProfile(using dataManager: DataOperator) {
        activityIndicator.startAnimating()
        setButtonsAreEnabled(false)
        dataManager.saveProfileData(changedProfile) {
            self.activityIndicator.stopAnimating()
            if $0 {
                self.showSucceesfulDataSaveOperationAlert()
                self.originalProfile = self.changedProfile
            }
            else {
                self.showFailedDataSaveOperationAlert(withDataManager: dataManager)
            }
            self.setButtonsAreEnabled(true)
        }
    }
    
    func loadProfileData() {
        activityIndicator.startAnimating()
        gcdBasedDataOperator.loadProfileData() {
            self.activityIndicator.stopAnimating()
            if let profile = $0 {
                self.originalProfile = profile
                self.changedProfile = profile
                self.updateView()
            }
        }
    }
    
    func updateView() {
        usernameField.text = originalProfile.name
        userinfoText.text = originalProfile.userInfo
        avatarImageView.image = originalProfile.userPicture
        textColorSampleLabel.textColor = originalProfile.textColor
    }
    
    func setButtonsAreEnabled(_ value: Bool) {
        saveProfileByGCDButton.isEnabled = value
        saveProfileByOperationButton.isEnabled = value
    }
    
    func setupDefaultActionsToSheet(_ sheet: UIAlertController) {
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
    
    func addDeleteActionToSheet(_ sheet: UIAlertController) {
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive) {
            [unowned self] action in
            
            self.avatarImageView.image = #imageLiteral(resourceName: "placeholder")
            self.changedProfile = self.changedProfile.createCopyWithChange(userPicture: #imageLiteral(resourceName: "placeholder"))
        })
    }
    
    func userPictureIsDefault() -> Bool {
        return self.avatarImageView.image == #imageLiteral(resourceName: "placeholder")
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let userPictureActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        setupDefaultActionsToSheet(userPictureActionSheet)
        if (!userPictureIsDefault()) {
            addDeleteActionToSheet(userPictureActionSheet)
        }
        present(userPictureActionSheet, animated: true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        avatarImageView.image = chosenImage
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
