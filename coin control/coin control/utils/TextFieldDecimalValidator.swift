//
//  TextFieldDecimalValidator.swift
//  coin control
//
//  Created by Stepan Konashenko on 28.10.2023.
//

import UIKit

public struct TextFieldDecimalValidator {
    
    static let validate: (UITextField, NSRange, String) -> Bool = { textField, _, string in
        
        let regex = "."
        let allowedChars = "0123456789"
        let allowedCharsWithPoint = ".0123456789"
        
        let currentAllowedChars: String
        
        if textField.text?.contains(regex) ?? false {
            currentAllowedChars = allowedChars
        } else {
            currentAllowedChars = allowedCharsWithPoint
        }
        return NSCharacterSet(charactersIn: currentAllowedChars).isSuperset(of: CharacterSet(charactersIn: string))
        
    }
}
