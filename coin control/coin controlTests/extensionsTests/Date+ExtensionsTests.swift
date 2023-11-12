//
//  Date+ExtensionsTests.swift
//  coin controlTests
//
//  Created by Stepan Konashenko on 12.11.2023.
//

import XCTest
@testable import coin_control

final class DateExtensionsTests: XCTestCase {

    func testShortFormatSuccessWhenDayAndMonthHavePerOneSignShouldReturnStringWithEightSigns() throws {
        
        try defaultAssertsCountSigns(days: 1...9, months: 1...9, expect: 8)
    }
    
    func testShortFormatSuccessWhenDayAndMonthHavePerTwoSignsShouldReturnStringWithTenSigns() throws {
        
        try defaultAssertsCountSigns(days: 10...12, months: 10...12, expect: 10)
    }
    
    func testShortFormatSuccessWhenDayHasOneSignAndMonthHasTwoSignsShouldReturnStringWithNineSigns() throws {
        
        try defaultAssertsCountSigns(days: 1...9, months: 10...12, expect: 9)
    }
    
    func testShortFormatSuccessWhenDayHasTwoSignsAndMonthHasOneSignShouldReturnStringWithNineSigns() throws {
        
        try defaultAssertsCountSigns(days: 10...12, months: 1...9, expect: 9)
    }
    
    private func defaultAssertsCountSigns(
        days dayRange: ClosedRange<Int>,
        months monthRange: ClosedRange<Int>,
        expect countSigns: Int
    ) throws {
        
        let day = Int.random(in: dayRange)
        let month = Int.random(in: monthRange)
        let date = dateFrom(year: 2023, month: month, day: day)
        let expectedDateRepresentation = "\(day).\(month).2023"
        
        let actualDateRepresentation = date.shortFormat()
        
        XCTAssertEqual(countSigns, actualDateRepresentation.count)
        XCTAssertEqual(expectedDateRepresentation, actualDateRepresentation)
    }
}

extension DateExtensionsTests {
    
    func dateFrom(year: Int, month: Int, day: Int) -> Date {
        DateComponents(calendar: Calendar.current, year: year, month: month, day: day).date!
    }
}
