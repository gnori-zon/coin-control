//
//  MockCurrencyRateResponseConverter.swift
//  coin controlTests
//
//  Created by Stepan Konashenko on 13.11.2023.
//

import Foundation
import coin_control

final class MockCurrencyRateResponseConverter: CurrencyRateResponseConverterProtocol {
    
    private var rate: CurrencyRateProtocol? = nil
    
    func convert(from response: CurrencyRateResponse) -> CurrencyRateProtocol? {
        rate
    }
    
    func shouldReturn(_ currencyRate: CurrencyRateProtocol) {
        rate = currencyRate
    }
}
