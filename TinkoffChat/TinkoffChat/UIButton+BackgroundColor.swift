//
//  UIButton+BackgroundColor.swift
//  TinkoffChat
//
//  Created by Alexander on 02/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setBackgroundColor(_ color: UIColor, for state: UIControlState) {
        setBackgroundImage(self.drawSolidColorImage(color: color), for: state)
    }
    
    fileprivate func drawSolidColorImage(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
