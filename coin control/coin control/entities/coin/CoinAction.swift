//
//  CoinAction.swift
//  coin control
//
//  Created by Stepan Konashenko on 21.10.2023.
//

import Foundation

public struct CoinAction: CoinActionProtocol {
    
    public let value: Decimal
    public let type: CoinActionType
    public let date: Date
    public let currency: CurrencyType
}
