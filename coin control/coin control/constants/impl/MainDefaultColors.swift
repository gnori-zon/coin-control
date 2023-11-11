//
//  MainDefaultColors.swift
//  coin control
//
//  Created by Stepan Konashenko on 21.10.2023.
//

import UIKit

public enum MainDefaultColors: DefaultColors {
    
    case background, text
    
    public func getUIColor() -> UIColor {
        
        switch self {
        case .background:
            return UIColor(red: 111 / 255, green: 27 / 255, blue: 171 / 255, alpha: 1)
        case .text:
            return UIColor(red: 252 / 255, green: 252 / 255, blue: 242 / 255, alpha: 1)
        }
    }
}
