//
//  CoinAction.swift
//  coin control
//
//  Created by Stepan Konashenko on 21.10.2023.
//

import Foundation

// MARK: - CoinActionProtocol

public protocol CoinActionProtocol {
    
    var date: Date { get }
    var value: Decimal { get }
    var type: CoinActionType { get }
    var currency: CurrencyType { get }
}

// MARK: - CoinAction

public struct CoinAction: CoinActionProtocol {
    
    public let date: Date
    public let value: Decimal
    public let type: CoinActionType
    public let currency: CurrencyType
}
