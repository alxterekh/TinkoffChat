//
//  RequestSender.swift
//  TinkoffChat
//
//  Created by Alexander on 09/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

protocol Requestable {
    var urlRequest: URLRequest? { get }
}

class Parser<T> {
    func parse(data: Data) -> T? { return nil }
}

struct RequestConfig<T> {
    let request: Requestable
    let parser: Parser<T>
}

enum Result<T> {
    case Success(T)
    case Fail(String)
}

protocol IRequestSender {
    func send<T>(config: RequestConfig<T>, completionHandler: @escaping (Result<T>) -> Void)
}

class RequestSender {
    
    let session = URLSession.shared
    
    func send<T>(config: RequestConfig<T>, completionHandler: @escaping (Result<T>) -> Void) {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(Result.Fail("url string bla bla bla"))
            
            return
        }
        
        let task = session.dataTask(with: urlRequest) {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                completionHandler(Result.Fail("some shit"))
                
                return
            }
            
            guard let data = data, let parserModel: T = config.parser.parse(data: data) else {
                completionHandler(Result.Fail("some shit"))
                
                return
            }
            
            completionHandler(Result.Success(parserModel))
        }
        task.resume()
    }
}
