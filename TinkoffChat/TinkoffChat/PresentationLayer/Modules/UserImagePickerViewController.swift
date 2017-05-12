//
//  UserImagePickerViewController.swift
//  TinkoffChat
//
//  Created by Alexander on 10/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit
import PKHUD

class UserImagePickerViewController: UIViewController, UserImagePickerModelDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let userImageCellId = "UserPicture"
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    fileprivate let itemsPerRow: CGFloat = 3
    
    fileprivate let userImagePickerModel = UserImagePickerModel()
    fileprivate var dataSource: [String] = []
    
    fileprivate var cashedImages: [UIImage] = []
    fileprivate var batchSize = 30

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        cell.image.image = #imageLiteral(resourceName: "placeholder")
        userImagePickerModel.fetchImageAtIndex() {
            image in
            cell.image.image = image
        }
        
        return cell
    }
}

extension UserImagePickerViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
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

