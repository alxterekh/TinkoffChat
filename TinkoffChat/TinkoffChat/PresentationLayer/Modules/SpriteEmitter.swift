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
    func moveToLocation(_ location: CGPoint)
    func startEmitting()
    func stopEmitting()
}

class SpriteEmitter {
    
    fileprivate let view: UIView
    fileprivate let emitterLayer = CAEmitterLayer()
  
    init(with view: UIView) {
        self.view = view
        setup()
    }
    
    fileprivate func setup() {
        emitterLayer.emitterPosition = CGPoint(x: 120, y: 320)
        let cell = CAEmitterCell()
        cell.emissionLongitude = -CGFloat.pi/2
        cell.birthRate = 1
        cell.alphaSpeed = -1
        cell.lifetime = 2.5
        cell.velocity = 120
        cell.scale = 0.2
        cell.emissionRange = CGFloat.pi/4
        cell.contents = #imageLiteral(resourceName: "blazon").cgImage
        emitterLayer.emitterCells = [cell]
        stop()
        view.layer.addSublayer(emitterLayer)
        
    }
    
    func changeEmitterLocation(_ location: CGPoint) {
        emitterLayer.emitterPosition = location
    }
    
    func start() {
        emitterLayer.birthRate = 20
    }
    
    func stop() {
        emitterLayer.birthRate = 0
    }
}
