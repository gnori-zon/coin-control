//
//  CurrencyRateResponseConverterTests.swift
//  coin controlTests
//
//  Created by Stepan Konashenko on 12.11.2023.
//

import XCTest
@testable import coin_control

final class CurrencyRateResponseConverterTests: XCTestCase {

    let converter = CurrencyRateResponseConverter()

    func testConvertSuccessShouldValidConvertFromCurrencyRateResponseToCurrencyRateProtocol() throws {
        
        try defaultAssertsConvert(
            baseType: .rub,
            rates: [.usd : 0.12, .eur : 15.1215]
        )
        
        try defaultAssertsConvert(
            baseType: .rub,
            rates: [.eur : 1.5]
        )
        
        try defaultAssertsConvert(
            baseType: .eur,
            rates: [.rub : 20.20, .usd : 12.41],
            year: 2012,
            month: 12,
            day: 1
        )
    }
    
    func testConvertFailureWhenRatesIsEmptyShouldReturnNils() {
        
        let dateWithRepresentation = dateWithRepresentationOf(year: 2000, month: 12, day: 1)
        
        let responseToConvert = CurrencyRateResponse(
            base: CurrencyType.rub.currencyRaw.str.uppercased(),
            date: dateWithRepresentation.representation,
            rates: Rates( eur: nil, rub: nil, usd: nil),
            success: true,
            timestamp: 123124124
        )
        
        let actualCurrencyRate = converter.convert(from: responseToConvert)
        
        XCTAssertNil(actualCurrencyRate?.date)
        XCTAssertNil(actualCurrencyRate?.targetCurrencyType)
        XCTAssertNil(actualCurrencyRate?.ratioCurrencies.count)
    }
    
    private func defaultAssertsConvert(
        baseType: CurrencyType,
        rates typesWithValues: [CurrencyType: Double],
        year: Int = 2023,
        month: Int = 11,
        day: Int = 20
    ) throws {
    
        let dateWithRepresentation = dateWithRepresentationOf(year: year, month: month, day: day)
        
        let responseToConvert = CurrencyRateResponse(
            base: baseType.currencyRaw.str.uppercased(),
            date: dateWithRepresentation.representation,
            rates: Rates(
                eur: typesWithValues[.eur],
                rub: typesWithValues[.rub],
                usd: typesWithValues[.usd]
            ),
            success: true,
            timestamp: 123124124
        )
        
        let actualCurrencyRate = converter.convert(from: responseToConvert)
        
        XCTAssertEqual(dateWithRepresentation.date, actualCurrencyRate?.date)
        XCTAssertEqual(baseType, actualCurrencyRate?.targetCurrencyType)
        XCTAssertEqual(typesWithValues.count, actualCurrencyRate?.ratioCurrencies.count)
       
        actualCurrencyRate?.ratioCurrencies.forEach { ratioCurrency in
                XCTAssertEqual("\(typesWithValues[ratioCurrency.type]!)", "\(ratioCurrency.value)")
            }
    }
    
    private func dateWithRepresentationOf(
        year: Int,
        month: Int,
        day: Int
    ) -> (date: Date, representation: String) {
        
        let dayString = day.representation(prefix: "0", if: { $0 < 10})
        let monthString = month.representation(prefix: "0", if: { $0 < 10})
        
        let dateStringRepresentation = "\(year)-\(monthString)-\(dayString)"
        
        let date = DateComponents(calendar: Calendar.current, year: year, month: month, day: day).date!
        
        return (date, dateStringRepresentation)
    }
}

fileprivate extension Int {
    
    func representation(prefix: String, if condition: (Int) -> Bool) -> String {
        
        return condition(self)
            ? "\(prefix)\(self)"
            : "\(self)"
    }
}
