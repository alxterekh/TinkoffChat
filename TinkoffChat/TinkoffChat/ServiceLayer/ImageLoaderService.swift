//
//  ImageLoaderService.swift
//  TinkoffChat
//
//  Created by Alexander on 11/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

class ImageLoaderService {
    
    fileprivate let requestSender: IRequestSender = RequestSender()
    
//    init(requestSender: IRequestSender) {
//        self.requestSender = requestSender
//    }
    
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
