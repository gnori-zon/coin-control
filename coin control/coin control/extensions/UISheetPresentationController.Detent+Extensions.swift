//
//  UISheetPresentationController.Detent+Extensions.swift
//  coin control
//
//  Created by Stepan Konashenko on 12.11.2023.
//

import UIKit

extension UISheetPresentationController.Detent {
    
    static func low() -> UISheetPresentationController.Detent {
        
        let detentId = UISheetPresentationController.Detent.Identifier.init("low")
        
        return UISheetPresentationController.Detent.custom(identifier: detentId) { context in
            return context.maximumDetentValue / 12
        }
    }
}
