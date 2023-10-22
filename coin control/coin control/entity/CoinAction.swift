//
//  CoinAction.swift
//  coin control
//
//  Created by Stepan Konashenko on 21.10.2023.
//

import Foundation

public struct CoinAction: CoinActionProtocol{
    
    let value: Decimal
    let type: CoinActionType
    let date: Date
    let currency: CurrencyType
}
