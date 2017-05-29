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
    fileprivate let duration: TimeInterval = 0.5
    fileprivate let textScale: CGFloat = 1.10
    fileprivate let textLabel: UILabel
    
    init(with label: UILabel) {
        self.textLabel = label
    }
    
    var textIsHighlighted: Bool = false {
        didSet {
            if textIsHighlighted {
                let transform = CGAffineTransform(scaleX: textScale, y: textScale)
                highlightText(with: transform, color: UIColor.black)
            }
            else {
                let transform = CGAffineTransform.identity
                highlightText(with: transform, color: UIColor.gray)
            }
        }
    }

    fileprivate func highlightText(with transform: CGAffineTransform, color: UIColor) {
        animateTextColorTransition(with: color)
        UIView.animate(withDuration: duration) {
            self.textLabel.transform = transform
        }
    }
    
    fileprivate func animateTextColorTransition(with color: UIColor) {
        UIView.transition(with: textLabel,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: { self.textLabel.textColor = color },
                          completion: nil)
    }
}
