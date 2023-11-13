//
//  Decimal+ExtensionsTests.swift
//  coin controlTests
//
//  Created by Stepan Konashenko on 12.11.2023.
//

import XCTest
@testable import coin_control

final class DecimalExtensionsTests: XCTestCase {

    func testCutSuccessWhenBoundaryNumberLessThanFiveShouldRoundDown() throws {
       
        try defaultAssertCut(partAfterPointToCut: 0.123_4, with: 3, expect: 0.123)
    }
    
    func testCutSuccessWhenBoundaryNumberGreaterThanFiveShouldRoundUp() throws {
       
        try defaultAssertCut(partAfterPointToCut: 0.12_77, with: 2, expect: 0.13)
    }
    
    func testCutSuccessWhenBoundaryNumberEqualFiveShouldRoundUp() throws {
       
        try defaultAssertCut(partAfterPointToCut: 0.12546_5, with: 5, expect: 0.12547)
    }
    
    private func defaultAssertCut(
        partAfterPointToCut: Decimal,
        with offsetAfterPoint: Int,
        expect partAfterPoint: Double
    ) throws {
        
        guard (0...1).contains(partAfterPointToCut) else {
            fatalError("[DecimalExtensionsTests] - numberAfterCut must be in range 0...1")
        }
        
        let randomNumberBeforePoint = Decimal(Int.random(in: 0...1000))
        var expectedNumberAfterCut = randomNumberBeforePoint.doubleValue + partAfterPoint
        var numberToCut = randomNumberBeforePoint + partAfterPointToCut
    
        if Bool.random() {
            numberToCut *= -1
            expectedNumberAfterCut *= -1
        }
        
        let actualNumberAfterCut = numberToCut.cut(with: offsetAfterPoint)
        
        XCTAssertEqual(expectedNumberAfterCut, actualNumberAfterCut)
    }
}
