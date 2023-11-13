//
//  CurrencyRateParserTests.swift
//  coin controlTests
//
//  Created by Stepan Konashenko on 13.11.2023.
//

import XCTest
@testable import coin_control

final class CurrencyRateParserTests: XCTestCase {
    
    @MainActor
    func testSuccessWhenResultSuccessAndConvertSuccessShoulInvokeCompletionHandler() async throws {
        
        try await defaultAssertInvokeMethod(expectIsInvoke: true) { converter, requestSender in
            
            let stubCurrencyRate = CurrencyRate(
                date: .now,
                targetCurrencyType: CurrencyType.eur,
                ratioCurrencies: []
            )
            
            let stubCurrencyRateResponse = CurrencyRateResponse(
                base: "",
                date: "",
                rates: Rates(eur: nil, rub: nil, usd: nil),
                success: true,
                timestamp: 1231
            )
            
            converter.shouldReturn(stubCurrencyRate)
            requestSender.shouldSuccess(stubCurrencyRateResponse)
        }
    }

    @MainActor
    func testFailureWhenResultFailureShouldDontInvokeCompletionHandler() async throws {
    
        try await defaultAssertInvokeMethod(expectIsInvoke: false) { converter, requestSender in
            
            requestSender.shouldError(HttpError.badResponseData)
        }
    }
    
    @MainActor
    func testFailureWhenResultSuccessAndConvertFailureShouldDontInvokeCompletionHandler() async throws {
    
        try await defaultAssertInvokeMethod(expectIsInvoke: false) { converter, requestSender in
            
            let stubCurrencyRateResponse = CurrencyRateResponse(
                base: "",
                date: "",
                rates: Rates(eur: nil, rub: nil, usd: nil),
                success: true,
                timestamp: 1231
            )
            
            requestSender.shouldSuccess(stubCurrencyRateResponse)
        }
    }
    
    private func defaultAssertInvokeMethod(
        expectIsInvoke: Bool,
        configureMocks: (MockCurrencyRateResponseConverter, MockHttpRequestSender) -> Void
    ) async throws {
        
        let mockConverter = MockCurrencyRateResponseConverter()
        let mockRequestSender = MockHttpRequestSender()
        let parser = CurrencyRateParser(converter: mockConverter, requestSender: mockRequestSender)
       
        let stubTarget = CurrencyType.eur
        let stubRatioCurrency = [CurrencyType]()
        
        configureMocks(mockConverter, mockRequestSender)
        
        var actualIsInvoked = false
        await parser.tryParse(target: stubTarget, ratioCurrencyTypes: stubRatioCurrency) { _ in
            actualIsInvoked = true
        }
        
        XCTAssertEqual(expectIsInvoke, actualIsInvoked)
    }
}
