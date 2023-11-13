//
//  TextFieldDecimalValidator.swift
//  coin control
//
//  Created by Stepan Konashenko on 28.10.2023.
//

import UIKit

public struct TextFieldDecimalValidator {
    
    static let validate: (UITextField, NSRange, String) -> Bool = { textField, _, string in
        
        guard let text = textField.text else {
            return false
        }
        
        guard !string.isEmpty else {
            return true
        }
        
        if text.isEmpty {
            return string.match("^((([1-9]0*)*|0)([.][0-9]*)?)$")
        }
        
        if text == "0" {
            return string.match("^([.][0-9]*)$")
        }
        
        if text.match("[.]") {
            return string.match("^[0-9]*$")
        }
        
        return string.match("^((([1-9]0?)*|0)([.][0-9]*)?)$")
    }
}
