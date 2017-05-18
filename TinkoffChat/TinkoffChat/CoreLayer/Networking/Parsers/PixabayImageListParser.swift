//
//  PixabayImageListParser.swift
//  TinkoffChat
//
//  Created by Alexander on 11/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ImageApiModel {
    let id: Int
    let url: String
}

class PixabayImageListParser: Parser<[ImageApiModel]> {
    override func parse(data: Data) -> [ImageApiModel]? {
        let json = JSON(data: data)
        guard let images = json["hits"].array else {
            return nil
        }
        
        var imageModels: [ImageApiModel] = []
        for image in images {
            guard let id = image["id"].int,
                let url =  image["webformatURL"].string else {
                    continue
            }
            imageModels.append(ImageApiModel(id: id, url: url))
        }
        
        return imageModels
    }
}
