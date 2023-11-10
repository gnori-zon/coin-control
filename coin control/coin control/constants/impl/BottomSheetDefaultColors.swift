//
//  BottomSheetDefaultColors.swift
//  coin control
//
//  Created by Stepan Konashenko on 28.10.2023.
//

import UIKit

public enum BottomSheetDefaultColors: DefaultColors {
    
    case background, text, titleText, fieldBackground, buttonText, buttonBackground
    
    
    public func getUIColor() -> UIColor {
        
        switch self {
        case .background, .text:
            return  UIColor(red: 197 / 255, green: 20 / 255, blue: 135 / 255, alpha: 1)
        case .fieldBackground, .titleText:
            return  UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0.85)
        case .buttonText:
            return UIColor(red: 252 / 255, green: 252 / 255, blue: 242 / 255, alpha: 1)
        case .buttonBackground:
            return UIColor(red: 111 / 255, green: 27 / 255, blue: 171 / 255, alpha: 1)
        }
    }
}
