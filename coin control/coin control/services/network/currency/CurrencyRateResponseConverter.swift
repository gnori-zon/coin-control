//
//  CurrencyRateResponseConverter.swift
//  coin control
//
//  Created by Stepan Konashenko on 08.11.2023.
//

import Foundation

// MARK: - CurrencyRateResponseConverterProtocol

public protocol CurrencyRateResponseConverterProtocol {
    
    func convert(from response: CurrencyRateResponse) -> CurrencyRateProtocol?
}

// MARK: - CurrencyRateResponseConverter

public struct CurrencyRateResponseConverter: CurrencyRateResponseConverterProtocol {
    
    public func convert(from response: CurrencyRateResponse) -> CurrencyRateProtocol? {
        
        let date = parseDate(response.date, format: "yyyy-MM-dd")
        let targetCurrencyType = CurrencyType.of(raw: response.base)
        let ratioCurrencies = response.rates.toRatioCurrencies()
                           
        guard let date, let targetCurrencyType, ratioCurrencies.isNotEmpty else {
            return nil
        }
                                                  
        return CurrencyRate(date: date, targetCurrencyType: targetCurrencyType, ratioCurrencies: ratioCurrencies)
    }
    
    private func parseDate(_ rawDate: String, format: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: rawDate)
    }
}

// MARK: Helpers (toRatioCurrencies, appendIfExist, isNotEmpty)

fileprivate extension Rates {
    
    func toRatioCurrencies() -> [RatioCurrency] {
        
        var ratioCurrencies = [RatioCurrency]()
        
        ratioCurrencies.appendIfExist(self.eur, type: .eur)
        ratioCurrencies.appendIfExist(self.usd, type: .usd)
        ratioCurrencies.appendIfExist(self.rub, type: .rub)
        
        return ratioCurrencies
    }
}

fileprivate extension Array where Element == RatioCurrency {
    
    mutating func appendIfExist(_ value: Double?, type: CurrencyType) {
        
        if let value {
            self.append(RatioCurrency(type: type, value: Decimal(value)))
        }
    }
    
    var isNotEmpty: Bool {
        
        let not = (!)
        return not(self.isEmpty)
    }
}
