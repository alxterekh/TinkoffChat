//
//  IRequest.swift
//  TinkoffChat
//
//  Created by Alexander on 11/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

protocol Requestable {
    var urlRequest: URLRequest? { get }
}
