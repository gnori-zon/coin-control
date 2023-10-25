//
//  CurrencyRate.swift
//  coin control
//
//  Created by Stepan Konashenko on 23.10.2023.
//

import Foundation

//MARK: - CurrencyRateProtocol

public protocol CurrencyRateProtocol {
    
    var ratioCurrencyType: CurrencyType { get }
    var targetCurrencyType: CurrencyType { get }
    var currencyValueRatio: Decimal { get }
}

//MARK: - CurrencyRateProtocol

public struct CurrencyRate: CurrencyRateProtocol {
    
    public let ratioCurrencyType: CurrencyType
    public let targetCurrencyType: CurrencyType
    public let currencyValueRatio: Decimal
}
