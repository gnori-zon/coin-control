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

public class CoinActionWriterInteractor: CoinActionWriterInteractorProtocol {
    
    weak var presenter: CoinActionWriterPresenterProtocol?
    private var storage: any StorageServiceProtocol = StorageService.shared()
    
    public func saveCoinAction(_ actionType: CoinActionType, _ value: String, _ currencyType: CurrencyType) {
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            
            let createdCoinAction = self.storage.create(type: CoinActionEntity.self) { entity in
                
                entity.actionType = actionType
                entity.currencyType = currencyType
                entity.date = .now
                entity.value = NSDecimalNumber.init(string: value)
            }
            
            guard let createdActionType = createdCoinAction?.actionType else {
                print("DEBUG: coin action not saved")
                return
            }
            
            NotificationCenter.default.post(name: .didAddCoinAction, object: createdActionType)
        }
    }
}

//MARK: - Notification.Name

extension Notification.Name {
    static let didAddCoinAction = Notification.Name("didAddCoinAction")
}
