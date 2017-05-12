//
//  ImageLoaderService.swift
//  TinkoffChat
//
//  Created by Alexander on 11/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit

class ImageLoaderService {
    
    fileprivate let requestSender: IRequestSender = RequestSender()
    
//    init(requestSender: IRequestSender) {
//        self.requestSender = requestSender
//    }
    
    func loadImage(url: String, completionHandler: @escaping(UIImage?, String?) -> Void) {
        let config = RequestsFactory.ImageConfig(for: url)
        requestSender.send(config: config) { (result: Result<UIImage>) in
            switch result {
            case .Success(let image):
                completionHandler(image, nil)
            case .Fail(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func loadImageList(completionHandler: @escaping ([ImageApiModel]?, String?) -> Void) {
        let config = RequestsFactory.ImageListConfig()
        requestSender.send(config: config) { (result: Result<[ImageApiModel]>) in
            switch result {
            case .Success(let images):
                completionHandler(images, nil)
            case .Fail(let error):
                completionHandler(nil, error)
            }
        }
    }
}
