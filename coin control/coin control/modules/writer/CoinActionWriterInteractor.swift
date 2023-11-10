//
//  CoinActionWriterInteractor.swift
//  coin control
//
//  Created by Stepan Konashenko on 27.10.2023.
//

import UIKit

// MARK: - CoinActionWriterPresenterProtocol

public protocol CoinActionWriterInteractorProtocol {
    
    func saveCoinAction(_ actionType: CoinActionType, _ value: String, _ currencyType: CurrencyType)
}

// MARK: - CoinActionWriterInteractor

public final class CoinActionWriterInteractor: CoinActionWriterInteractorProtocol {
    
    weak var presenter: CoinActionWriterPresenterProtocol?
    var coinActionService: CoinActionServiceProtocol
    
    public init(_ coinActionService: CoinActionServiceProtocol) {
        self.coinActionService = coinActionService
    }
    
    public func saveCoinAction(_ actionType: CoinActionType, _ value: String, _ currencyType: CurrencyType) {
        coinActionService.saveCoinAction(actionType, value, currencyType)
    }
}
