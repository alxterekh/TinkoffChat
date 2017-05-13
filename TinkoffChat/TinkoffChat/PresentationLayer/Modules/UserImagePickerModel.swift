//
//  UserImagePickerModel.swift
//  TinkoffChat
//
//  Created by Alexander on 11/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit

protocol ImagePickerModel: class {
    weak var delegate: UserImagePickerModelDelegate? { get set }
    func fetchImagesList()
}

protocol UserImagePickerModelDelegate: class {
    func setup(dataSource: [String])
    func show(error message: String)
}

class UserImagePickerModel : ImagePickerModel {
    
    weak var delegate: UserImagePickerModelDelegate?
    let imageLoaderService = ServiceAssembly.imageLoaderService()
    
    func fetchImage(at url: String, completionHandler: @escaping(UIImage?) -> Void) {
        imageLoaderService.loadImage(url: url) {
            if let image  = $0 {
                completionHandler(image)
            } else {
                self.delegate?.show(error: $1 ?? "Error")
            }
        }
    }
    
    func fetchImagesList() {
        imageLoaderService.loadImageList {
            if let images = $0 {
                let urls = images.map{ $0.url }
                self.delegate?.setup(dataSource: urls)
            } else {
                self.delegate?.show(error: $1 ?? "Error")
            }
        }
    }
}
