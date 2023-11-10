//
//  CoinActionService.swift
//  coin control
//
//  Created by Stepan Konashenko on 08.11.2023.
//

import Foundation

public protocol CoinActionServiceProtocol {
    
    func getAll(for tile: CoinActionTileSettingsEntity) -> [CoinActionEntity]
    func saveCoinAction(_ actionType: CoinActionType, _ value: String, _ currencyType: CurrencyType)
}

public final class CoinActionService: CoinActionServiceProtocol {
    
    private let storage: some StorageServiceProtocol = StorageService.shared()

    public func getAll(for tileEntity: CoinActionTileSettingsEntity) -> [CoinActionEntity] {
        
        let filter = FilterEntity(field: .actionTypeCode, sign: .equals, value: tileEntity.coinActionType.rawValue)
        let compoundFilterEntity = CompoundFilterEntity(filters: [filter], joiner: .and)
        let sorting: SortingEntity = (type: tileEntity.sortingType, direction: tileEntity.sortingDirection)
        
        return storage.fetch(type: CoinActionEntity.self, where: compoundFilterEntity, orderBy: [sorting])
    }
    
    public func saveCoinAction(_ actionType: CoinActionType, _ value: String, _ currencyType: CurrencyType) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
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
