//
//  Decimal+Extensions.swift
//  coin control
//
//  Created by Stepan Konashenko on 12.11.2023.
//

import Foundation

extension Decimal {
    
    func cut(with offsetAfterPoint: Int) -> Double {
        
        let selfValue = doubleValue
        let rounder = pow(10, offsetAfterPoint).doubleValue
    
        return Double(round(selfValue * rounder) / rounder)
    }
    
    var doubleValue: Double {
        (self as NSDecimalNumber).doubleValue
    }
}
