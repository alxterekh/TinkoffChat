//
//  PixabayImageListRequest.swift
//  TinkoffChat
//
//  Created by Alexander on 11/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

class PixabayImageListRequest : Requestable {
    fileprivate let baseUrl: String = "https://pixabay.com/"
    fileprivate let apiKey: String
    
    // MARK: - Initialization
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    fileprivate var urlString: String {
        return "https://pixabay.com/api/?key=5332108-70759dac755dbffb54facfa1e&q=yellow+flowers&image_type=photo"
            //baseUrl + "?key=\(apiKey)" + "&q=yellow+flowers&image_type=photo&pretty=true&per_pag e=100"
    }
    
    // MARK: - 
    
    var urlRequest: URLRequest? {
        if let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: urlString) {
                
                return URLRequest(url: url)
            }
        }
        
        return nil
    }    
}
