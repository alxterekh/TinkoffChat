//
//  RequestsFactory.swift
//  TinkoffChat
//
//  Created by Alexander on 11/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit

class RequestsFactory {
    
    fileprivate static let apiKey = "5332108-70759dac755dbffb54facfa1e"
    
    static func ImageListConfig() -> RequestConfig<[ImageApiModel]> {
        let request = PixabayImageListRequest(apiKey: apiKey)
        return RequestConfig<[ImageApiModel]>(request:request, parser: PixabayImageListParser())
    }
    
    static func ImageConfig(for url: String) -> RequestConfig<UIImage> {
        let request = ImageRequest(url: url)
        return RequestConfig<UIImage>(request:request, parser: ImageParser())
    }
}
