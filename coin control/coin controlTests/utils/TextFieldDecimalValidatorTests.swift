//
//  TextFieldDecimalValidatorTests.swift
//  coin controlTests
//
//  Created by Stepan Konashenko on 12.11.2023.
//

import XCTest
@testable import coin_control

final class TextFieldDecimalValidatorTests: XCTestCase {
        
    func testValidateSuccessWhenOldValueAndNewValueIsValidShouldReturnTrue() throws {
        
        defaultAssertValidate(
            oldValue: "\(Int.positiveRandom())",
            newValue: "\(Int.positiveRandom(withZero: true))",
            expect: true
        )
        
        defaultAssertValidate(
            oldValue: "",
            newValue: "\(Int.positiveRandom())",
            expect: true
        )
        
        defaultAssertValidate(
            oldValue: "",
            newValue: ".",
            expect: true
        )
        
        defaultAssertValidate(
            oldValue: "\(Double.positiveRandom())",
            newValue: "\(Int.positiveRandom(withZero: true))",
            expect: true
        )
        
        defaultAssertValidate(
            oldValue: "",
            newValue: "\(Double.positiveRandom())",
            expect: true
        )
        
        defaultAssertValidate(
            oldValue: "\(Int.positiveRandom())",
            newValue: "\(Double.positiveRandom(withZero: true))",
            expect: true
        )
        
        defaultAssertValidate(
            oldValue: ".",
            newValue: "\(Int.positiveRandom(withZero: true))",
            expect: true
        )
    }
    
    func testValidateSuccessWhenOldNewValueIsNotValidShouldReturnFalse() throws {
        
        defaultAssertValidate(
            oldValue: "0",
            newValue: "\(Int.positiveRandom(withZero: true))",
            expect: false
        )
        
        defaultAssertValidate(
            oldValue: "0",
            newValue: "0",
            expect: false
        )
        
        defaultAssertValidate(
            oldValue: "\(Double.positiveRandom())",
            newValue: "\(Double.positiveRandom())",
            expect: false
        )
        
        defaultAssertValidate(
            oldValue: "0",
            newValue: "\(Double.positiveRandom())",
            expect: false
        )
        
        defaultAssertValidate(
            oldValue: "",
            newValue: "asdlk",
            expect: false
        )
    }
    
    private func defaultAssertValidate(
        oldValue: String,
        newValue: String,
        expect resultValidation: Bool
    ) {
        
        let textField = UITextField()
        let stubNSRange = NSRange()
        
        textField.text = oldValue
                
        let actualResultValidation = TextFieldDecimalValidator.validate(textField, stubNSRange, newValue)
        XCTAssertEqual(resultValidation, actualResultValidation)
    }
}

fileprivate extension Int {
    
    static func positiveRandom(withZero: Bool = false) -> Int {
        
        switch withZero {
        case true:
            return Int.random(in: 0...Int.max)
        case false:
            return Int.random(in: 1...Int.max)
        }
    }
}

fileprivate extension Double {
    
    static func positiveRandom(withZero: Bool = false, max: Double = 1_000_000_000_000) -> Double {
        
        switch withZero {
        case true:
            return Double.random(in: 0...max)
        case false:
            return Double.random(in: 1...max)
        }
    }
}
    
    
    
