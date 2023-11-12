//
//  String+Extensions.swift
//  coin controlTests
//
//  Created by Stepan Konashenko on 12.11.2023.
//

import XCTest
@testable import coin_control

final class StringExtensionsTests: XCTestCase {
    
    let regexPattern = "^[1-5]+$" /// - stub pattern regex (valid cases is all number when all digits include in [1, 2, 3, 4, 5])
    
    func testMatchSuccessWhenStringIsValidShouldReturnTrue() throws {
                
        XCTAssertTrue("1231123".match(regexPattern))
        XCTAssertTrue("54321".match(regexPattern))
        XCTAssertTrue("5".match(regexPattern))
    }
    
    func testMatchSuccessWhenStringIsNotValidShouldReturnFalse() throws {
        
        XCTAssertFalse("".match(regexPattern))
        XCTAssertFalse("zsdasd".match(regexPattern))
        XCTAssertFalse("51257".match(regexPattern))
        XCTAssertFalse("5125 ".match(regexPattern))
    }
}
