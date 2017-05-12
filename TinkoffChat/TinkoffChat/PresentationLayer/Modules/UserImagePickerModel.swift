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
    
    func fetchImageAtIndex(completionHandler: @escaping(UIImage) -> Void) {
        imageLoaderService.loadImage(url: "https://cdn.pixabay.com/photo/2013/10/15/09/20/flower-195897_150.jpg") {
            (image, error) in
            
            if let image  = image {
                completionHandler(image)
            } else {
                self.delegate?.show(error: error ?? "Error")
            }
            
        }
    }
    
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
