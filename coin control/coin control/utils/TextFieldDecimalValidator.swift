//
//  TextFieldDecimalValidator.swift
//  coin control
//
//  Created by Stepan Konashenko on 28.10.2023.
//

import UIKit

public struct TextFieldDecimalValidator {
    
    static let validate: (UITextField, NSRange, String) -> Bool = { textField, _, string in
        
        let point = "."
        let regexDigit = "[1-9]"
        let allowedCharsWithoutZero = "123456789"
        let allowedChars = "0123456789"
        let allowedCharsWithPoint = ".0123456789"
        let allowedCharsWithPointAndWithoutZero = ".123456789"
        
        let currentAllowedChars: String
        
        if textField.text?.contains(point) ?? false {
            if textField.text?.match(regexDigit) ?? false {
                currentAllowedChars = allowedChars
            } else {
                currentAllowedChars = allowedCharsWithoutZero
            }
        } else {
            if textField.text?.match(regexDigit) ?? false {
                currentAllowedChars = allowedCharsWithPoint
            } else {
                currentAllowedChars = allowedCharsWithPointAndWithoutZero
            }
        }
        return NSCharacterSet(charactersIn: currentAllowedChars).isSuperset(of: CharacterSet(charactersIn: string))
    }
}

fileprivate extension String {
    
    func match(_ pattern: String) -> Bool {
        
        do {
            return try self.matches(of: Regex(pattern)).count > 0
        } catch {
            return false
        }
    }
}
