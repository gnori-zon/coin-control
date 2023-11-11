//
//  DefaultAnimationsProtocol.swift
//  coin control
//
//  Created by Stepan Konashenko on 31.10.2023.
//

import UIKit

public protocol DefaultAnimationsProtocol {
    
    func snake(_ view: UIView)
}

public extension DefaultAnimationsProtocol {
    
    func snake(_ view: UIView) {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 4, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 4, y: view.center.y))
        
        view.layer.add(animation, forKey: "position")
    }
}
