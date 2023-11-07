//
//  CurrencyRate.swift
//  coin control
//
//  Created by Stepan Konashenko on 23.10.2023.
//

import Foundation

//MARK: - CurrencyRateProtocol

public typealias RatioCurrency = (type: CurrencyType, value: Decimal)

public protocol CurrencyRateProtocol {
    
    var date: Date { get }
    var targetCurrencyType: CurrencyType { get }
    var ratioCurrencies: [RatioCurrency] { get }
}

//MARK: - CurrencyRateProtocol

public struct CurrencyRate: CurrencyRateProtocol {
    
    public let date: Date
    public let targetCurrencyType: CurrencyType
    public let ratioCurrencies: [RatioCurrency]
}
