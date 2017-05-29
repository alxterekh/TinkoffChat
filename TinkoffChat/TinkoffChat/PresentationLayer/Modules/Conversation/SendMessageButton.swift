//
//  SendMessageButton.swift
//  TinkoffChat
//
//  Created by Alexander on 25/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class SendMessageButton: UIButton {
    
    fileprivate let animationDuration = 0.5
    fileprivate let scaleFactor: CGFloat = 1.15
    
    fileprivate let defaultColor = UIColor.gray
    fileprivate let userInteractableColor = UIColor(red: 255/255, green: 234/255, blue: 67/255, alpha: 1)
    
    var isActive: Bool = false {
        didSet {
            if isActive != oldValue {
                self.isEnabled = isActive
                let color = isActive ? userInteractableColor : defaultColor
                animateButton(with: color)
            }
        }
    }
    
    fileprivate func animateButton(with color: UIColor) {
        UIView.animate(withDuration: animationDuration,
                       animations: {
                        self.backgroundColor = color
                        self.transform = CGAffineTransform(scaleX: self.scaleFactor, y: self.scaleFactor)
        },
                       completion: { _ in
                        UIView.animate(withDuration: self.animationDuration) {
                            self.transform = CGAffineTransform.identity
                        }
        })
    }
}
