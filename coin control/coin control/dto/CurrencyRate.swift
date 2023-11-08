//
//  CurrencyRate.swift
//  coin control
//
//  Created by Stepan Konashenko on 23.10.2023.
//

import Foundation

//MARK: - CurrencyRateProtocol

public protocol CurrencyRateProtocol {
    
    var date: Date { get }
    var targetCurrencyType: CurrencyType { get }
    var ratioCurrencies: [RatioCurrency] { get }
}

//MARK: - CurrencyRate

public struct CurrencyRate: CurrencyRateProtocol {
    
    public let date: Date
    public let targetCurrencyType: CurrencyType
    public let ratioCurrencies: [RatioCurrency]
}

// MARK: - extension Codable

extension CurrencyRate: Codable {}

