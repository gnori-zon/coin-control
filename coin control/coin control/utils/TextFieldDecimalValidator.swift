//
//  TextFieldDecimalValidator.swift
//  coin control
//
//  Created by Stepan Konashenko on 28.10.2023.
//

import UIKit

public struct TextFieldDecimalValidator {
    
    static let validate: (UITextField, NSRange, String) -> Bool = { textField, _, string in
        
        let decimalRegex = "^(0[.][0-9]+|[1-9]+[.]?[0-9]*)$"
        
        guard let text = textField.text else {
            return false
        }
        
        guard !string.isEmpty else {
            return true
        }
        
        return "\(text)\(string)".match(decimalRegex)
    }
}
