//
//  BottomSheetDefaultColors.swift
//  coin control
//
//  Created by Stepan Konashenko on 28.10.2023.
//

import UIKit

public enum BottomSheetDefaultColors: DefaultColors {
    
    case background, text
    
    
    public func getUIColor() -> UIColor {
        
        switch self {
        case .background:
            return  UIColor(red: 197 / 255, green: 20 / 255, blue: 135 / 255, alpha: 1)
        case .text:
            return  UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0.85)
        }
    }
}
