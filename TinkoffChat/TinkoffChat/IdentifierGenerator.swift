//
//  IdentifierGenerator.swift
//  TinkoffChat
//
//  Created by Alexander on 22/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

class IdentifierGenerator {
    static func generateIdentifier() -> String {
        return ("\(arc4random_uniform(UINT32_MAX)) + \(Date.timeIntervalSinceReferenceDate) + \(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString())!
    }
}


