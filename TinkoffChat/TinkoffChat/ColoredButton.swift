//
//  ColoredButton.swift
//  TinkoffChat
//
//  Created by Alexander on 02/04/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

final class ColoredButton : UIButton {
    @IBInspectable var normalBackgroundColor: UIColor = UIColor.white {
        didSet {
            setBackgroundColor(normalBackgroundColor, for: .normal)
        }
    }
    
    @IBInspectable var disabledBackgroundColor: UIColor = UIColor.gray {
        didSet {
            setBackgroundColor(disabledBackgroundColor, for: .disabled)
        }
    }
}
