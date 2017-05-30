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
    func startEmittingForTouch(_ touch: UITouch)
    func stopEmitting()
}

class SpriteEmitter : Emitter {
    
    fileprivate let window: UIWindow
    fileprivate var emitterLayer = CAEmitterLayer()
    
    init(with window: UIWindow) {
        self.window = window
        setupConfig()
    }
    
    fileprivate func setupConfig() {
        emitterLayer.emitterCells = [makeEmitterCell()]
        emitterLayer.zPosition = .greatestFiniteMagnitude
        emitParticles(false)
        window.layer.addSublayer(emitterLayer)
    }
    
    fileprivate func makeEmitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.emissionLongitude = -CGFloat.pi/2
        cell.alphaSpeed = -0.5
        cell.birthRate = 25
        cell.lifetime = 2.5
        cell.velocity = 120
        cell.scale = 0.2
        cell.emissionRange = CGFloat.pi/4
        cell.contents = #imageLiteral(resourceName: "blazon").cgImage
        
        return cell
    }
    
    //¯\_(ツ)_/¯ because emitterLayer.birthRate works very strange
    fileprivate func emitParticles(_ value: Bool) {
        emitterLayer.lifetime = value ? 1 : 0
    }
        
    func moveToTouch(_ touch: UITouch) {
        let location = touch.location(in: window)
        emitterLayer.emitterPosition = location
    }
    
    func startEmittingForTouch(_ touch: UITouch) {
        emitParticles(true)
        moveToTouch(touch)
    }
    
    func stopEmitting() {
        emitParticles(false)
    }
}
