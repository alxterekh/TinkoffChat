//
//  ImageParser.swift
//  TinkoffChat
//
//  Created by Alexander on 12/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit

class ImageParser: Parser<UIImage> {
    override func parse(data: Data) -> UIImage? {
        return UIImage(data: data)
    }
}
