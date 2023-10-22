//
//  CoinActionProtocol.swift
//  coin control
//
//  Created by Stepan Konashenko on 21.10.2023.
//

import Foundation

protocol CoinActionProtocol {
    
    var value: Decimal { get }
    var type: CoinActionType { get }
    var date: Date { get }
    var currency: CurrencyType { get }
}
