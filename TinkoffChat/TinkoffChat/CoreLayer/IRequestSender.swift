//
//  IRequestSender.swift
//  TinkoffChat
//
//  Created by Alexander on 11/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

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
