//
//  UserImagePickerModel.swift
//  TinkoffChat
//
//  Created by Alexander on 11/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit

protocol IUserImagePickerModel: class {
    weak var delegate: UserImagePickerModelDelegate? { get set }
    func fetchImagesList()
}

protocol UserImagePickerModelDelegate: class {
    func setup(dataSource: [String])
    func show(error message: String)
}

class UserImagePickerModel {
    
    weak var delegate: UserImagePickerModelDelegate?
    
    let imageLoaderService = ImageLoaderService()
    
    func fetchImagesList() {
        imageLoaderService.loadImageList {
             (images: [ImageApiModel]?, error) in
            
            if let images = images {
                let urls = images.map{ $0.previewUrl }
                self.delegate?.setup(dataSource: urls)
            } else {
                self.delegate?.show(error: error ?? "Error")
            }
        }
    }
}
