//
//  TileDefaultColors.swift
//  coin control
//
//  Created by Stepan Konashenko on 21.10.2023.
//

import UIKit

public enum TileDefaultColors: DefaultColors {
    
    case background, text
    
    public func getUIColor() -> UIColor {
        
        switch self {
        case .background:
            return UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0.85)
        case .text:
            return UIColor(red: 111 / 255, green: 27 / 255, blue: 171 / 255, alpha: 1)
        }
    }
}
