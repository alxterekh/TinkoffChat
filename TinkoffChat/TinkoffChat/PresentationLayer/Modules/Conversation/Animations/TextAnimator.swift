//
//  TextAnimator.swift
//  TinkoffChat
//
//  Created by Alexander on 29/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit

class TextAnimator {
    fileprivate let duration: TimeInterval = 1
    fileprivate let textScale: CGFloat = 1.10
    fileprivate let textLabel: UILabel
    
    init(with label: UILabel) {
        self.textLabel = label
    }
    
    var textIsHighlighted: Bool = false {
        didSet {
            if textIsHighlighted {
                let transform = CGAffineTransform(scaleX: textScale, y: textScale)
                highlightText(with: UIColor.black, transform: transform)
            }
            else {
                let transform = CGAffineTransform.identity
                highlightText(with: UIColor.gray, transform: transform)
            }
        }
    }
    
    fileprivate func highlightText(with color: UIColor, transform: CGAffineTransform) {
        UIView.transition(with: textLabel,
                          duration: duration,
                          options: [.preferredFramesPerSecond60, .transitionCrossDissolve],
                          animations: {
                            self.textLabel.textColor = color
                            self.textLabel.transform = transform },
                          completion: nil)
    }
}
