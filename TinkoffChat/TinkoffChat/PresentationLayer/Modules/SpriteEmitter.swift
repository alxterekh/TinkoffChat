//
//  SpriteEmitter.swift
//  TinkoffChat
//
//  Created by Alexander on 24/05/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit

protocol Emitter {
    func moveToTouch(_ touch: UITouch)
    func start()
    func stop()
}

class SpriteEmitter : Emitter {
    
    fileprivate let window: UIWindow
    fileprivate var emitterLayer = CAEmitterLayer()
    
    init(with window: UIWindow) {
        self.window = window
        setup()
    }
    
    fileprivate func setup() {
        let cell = CAEmitterCell()
        cell.emissionLongitude = -CGFloat.pi/2
        cell.alphaSpeed = -0.5
        cell.birthRate = 1
        cell.lifetime = 2.5
        cell.velocity = 120
        cell.scale = 0.2
        cell.emissionRange = CGFloat.pi/4
        cell.contents = #imageLiteral(resourceName: "blazon").cgImage
        emitterLayer.emitterCells = [cell]
        emitterLayer.zPosition = CGFloat.greatestFiniteMagnitude
        window.layer.addSublayer(emitterLayer)
    }
    
    func moveToTouch(_ touch: UITouch) {
        let location = touch.location(in: window)
        emitterLayer.emitterPosition = location
    }
    
    func start() {
        emitterLayer.birthRate = 25
    }
    
    func stop() {
        emitterLayer.birthRate = 0
    }
}
