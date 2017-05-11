//
//  RequestsFactory.swift
//  TinkoffChat
//
//  Created by Alexander on 11/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

class RequestsFactory {
    
    fileprivate static let apiKey = "5332108-70759dac755dbffb54facfa1e"
    
    static func ImageListConfig() -> RequestConfig<[ImageApiModel]> {
        let request = PixabayImageRequest(apiKey: apiKey)
        return RequestConfig<[ImageApiModel]>(request:request, parser: PixabayImageListParser())
    }
}
