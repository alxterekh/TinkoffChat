//
//  UserImagePickerViewController.swift
//  TinkoffChat
//
//  Created by Alexander on 10/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit
import PKHUD

protocol UserImagePickerViewControllerDelegate: class {
    func updateUserPicture(_ image: UIImage)
}

class UserImagePickerViewController: UIViewController, UserImagePickerModelDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let userImageCellId = "UserPicture"
    fileprivate let sectionInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let userImagePickerModel = UserImagePickerModel()
    fileprivate var dataSource: [String] = []
    fileprivate var cashedImages: [IndexPath : UIImage] = [:]
        
    weak var delegate: UserImagePickerViewControllerDelegate?
    
    @IBAction func dismissUserImagePicker(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLayout()
    }
    
    fileprivate func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        userImagePickerModel.delegate = self
        userImagePickerModel.fetchImagesList()
        DispatchQueue.main.async {
            HUD.show(.progress, onView: self.view)
        }
    }
    
    fileprivate func setupLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsets
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
    }
    
    // MARK: - UserImagePickerModelDelegate
    
    func setup(dataSource: [String]) {
        self.dataSource = dataSource
        DispatchQueue.main.async {
            HUD.flash(.success, onView: self.view)
            self.collectionView.reloadData()
        }
    }
    
    func show(error message: String) {
        DispatchQueue.main.async {
            HUD.flash(.labeledError(title: message, subtitle: nil), onView: self.view)
        }
    }
}

extension UserImagePickerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! UserImageCell
        if let image = cell.imageView.image {
            delegate?.updateUserPicture(image)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension UserImagePickerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userImageCellId,
                                                      for: indexPath) as! UserImageCell
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        fetchImage(for: cell, at: indexPath)
        
        return cell
    }
    
    fileprivate func fetchImage(for cell: UserImageCell, at indexPath: IndexPath) {
        let image = cashedImages[indexPath]
        cell.configure(with: image)
        let url = dataSource[indexPath.row]
        cell.url = url
        if image == nil {
            userImagePickerModel.fetchImage(at: url) {
                self.cashImage($0, at: indexPath)
                if cell.url == url {
                    cell.configure(with: $0)
                }
            }
        }
    }
    
    fileprivate func cashImage(_ image: UIImage?, at indexPath: IndexPath) {
        if let image = image {
            cashedImages[indexPath] = image
        }
    }
}

extension UserImagePickerViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = floor(availableWidth / itemsPerRow)
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

