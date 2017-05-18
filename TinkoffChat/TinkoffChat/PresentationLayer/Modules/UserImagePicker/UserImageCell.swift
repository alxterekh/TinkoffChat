//
//  UserImageCell.swift
//  TinkoffChat
//
//  Created by Alexander on 10/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit

class UserImageCell: UICollectionViewCell {
        
    @IBOutlet weak var imageView: UIImageView!
    
    var url:String?
        
    func configure(with image: UIImage?) {
        imageView.image = (image != nil) ? image : #imageLiteral(resourceName: "placeholder")
    }
}
