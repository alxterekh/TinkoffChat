//
//  MagicWindow.swift
//  TinkoffChat
//
//  Created by Alexander on 27/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

final class TouchableWindow: UIWindow {
    
    fileprivate var emitter: Emitter?
    
    override func draw(_ rect: CGRect) {
        emitter = SpriteEmitter(with: self)
    }
    
    override func sendEvent(_ event: UIEvent) {
        if let touches = event.allTouches {
            for touch in touches {
                switch touch.phase {
                case .began:
                    emitter?.startEmittingForTouch(touch)
                case .moved:
                    emitter?.moveToTouch(touch)
                case .ended, .cancelled:
                    emitter?.stopEmitting()
                default:
                    break
                }
            }
        }
        
        super.sendEvent(event)
    }
}
