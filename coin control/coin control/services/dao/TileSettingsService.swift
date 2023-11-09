//
//  TileSettingsService.swift
//  coin control
//
//  Created by Stepan Konashenko on 01.11.2023.
//

import CoreData

public typealias InstanceTileSettingsEntityProtocol = TileSettingsEntityProtocol & NSManagedObject

public protocol TileSettingsServiceProtocol {
    
    func getAllTileSettings() -> [any InstanceTileSettingsEntityProtocol]
    func getAllTileSettings<T: InstanceTileSettingsEntityProtocol> (type: T.Type, filtering: CompoundFilterEntity) -> [T]
}

public struct TileSettingsService: TileSettingsServiceProtocol {
    
    private let storage: some StorageServiceProtocol = StorageService.shared()
    
    public func getAllTileSettings() -> [any InstanceTileSettingsEntityProtocol] {
        
        var tileSettings: [any InstanceTileSettingsEntityProtocol] = storage.fetch(type: CoinActionTileSettingsEntity.self)
        storage.fetch(type: CurrencyRateTileSettingsEntity.self).forEach { tileSettings.append($0) }
        
        if tileSettings.count < 1 {
            return createDefaultTileSettings()
        }
        
        return tileSettings
    }
        
    public func getAllTileSettings<T: InstanceTileSettingsEntityProtocol> (type: T.Type, filtering: CompoundFilterEntity) -> [T] {
        return storage.fetch(type: type, where: filtering)
    }
    
    private func createDefaultTileSettings() -> [any InstanceTileSettingsEntityProtocol] {
                
        let incomeTileSettings = CoinActionTileSettingsEntity.defaultOf(from: storage, title: "Прибыль", type: .income)
        let outcomeTileSettings = CoinActionTileSettingsEntity.defaultOf(from: storage, title: "Траты", type: .outcome)
        let coursesTileSettings = CurrencyRateTileSettingsEntity.defaultOf(from: storage, title: "Курсы")
        
        return [incomeTileSettings, outcomeTileSettings, coursesTileSettings].compactMap { $0 }
    }
}

// MARK: - defaultOf

fileprivate extension CoinActionTileSettingsEntity {
    
    static func defaultOf(from storage: some StorageServiceProtocol, title: String, type coinActionType: CoinActionType) -> CoinActionTileSettingsEntity? {
        
        return storage.create(type: CoinActionTileSettingsEntity.self) { tileSettings in
            
            tileSettings.currencyType = .rub
            tileSettings.coinActionType = coinActionType
            tileSettings.sortingDirection = .desc
            tileSettings.sortingType = .date
            tileSettings.title = title
        }
    }
}

fileprivate extension CurrencyRateTileSettingsEntity {
    
    static func defaultOf(from storage: some StorageServiceProtocol, title: String) -> CurrencyRateTileSettingsEntity? {
        
        return storage.create(type: CurrencyRateTileSettingsEntity.self) { tileSettings in
            
            tileSettings.title = title
            tileSettings.selectedCurrencies = [.usd, .eur]
            tileSettings.targetCurrencyType = .rub
        }
    }
}
