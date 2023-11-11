//
//  RatioCurrency.swift
//  coin control
//
//  Created by Stepan Konashenko on 08.11.2023.
//

import Foundation

// MARK: - RatioCurrencyProtocol

public protocol RatioCurrencyProtocol {
    
    var type: CurrencyType { get }
    var value: Decimal { get }
}

// MARK: - RatioCurrency

public struct RatioCurrency: RatioCurrencyProtocol {
    
    public let type: CurrencyType
    public let value: Decimal
}
