//
//  CoinActionService.swift
//  coin control
//
//  Created by Stepan Konashenko on 08.11.2023.
//

import Foundation

public protocol CoinActionServiceProtocol {
    
    func getAll(for tile: CoinActionTileSettingsEntity) -> [CoinActionEntity]
}

public struct CoinActionService: CoinActionServiceProtocol {
    
    private let storage: some StorageServiceProtocol = StorageService.shared()

    public func getAll(for tileEntity: CoinActionTileSettingsEntity) -> [CoinActionEntity] {
        
        let filter = FilterEntity(field: .actionTypeCode, sign: .equals, value: tileEntity.coinActionType.rawValue)
        let compoundFilterEntity = CompoundFilterEntity(filters: [filter], joiner: .and)
        let sorting: SortingEntity = (type: tileEntity.sortingType, direction: tileEntity.sortingDirection)
        
        return storage.fetch(type: CoinActionEntity.self, where: compoundFilterEntity, orderBy: [sorting])
    }
}
