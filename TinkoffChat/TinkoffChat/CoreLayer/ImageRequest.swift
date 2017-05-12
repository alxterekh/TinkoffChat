//
//  ImageRequest.swift
//  TinkoffChat
//
//  Created by Alexander on 11/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

class ImageRequest : Requestable {
    fileprivate let urlString: String
    
    // MARK: - Initialization
    
    init(url: String) {
        self.urlString = url
    }
        
    var urlRequest: URLRequest? {
        if let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: urlString) {
                
                return URLRequest(url: url)
            }
        }
        
        return nil
    }
}
