//
//  TileSettingsService.swift
//  coin control
//
//  Created by Stepan Konashenko on 01.11.2023.
//

public protocol TileSettingsServiceProtocol {
    
    func getAllTileSettings() -> [any TileSettingsProtocol]
}

public struct TileSettingsService: TileSettingsServiceProtocol {
    
    private let storage: some StorageServiceProtocol = StorageService.shared()
    private var defaultTileSettings: [any TileSettingsProtocol] {
                
        let incomeTileSettings = CoinActionTileSettingsEntity.defaultOf(from: storage, title: "Прибыль", type: .income)
        let outcomeTileSettings = CoinActionTileSettingsEntity.defaultOf(from: storage, title: "Траты", type: .outcome)
        let coursesTileSettings = CurrencyRateTileSettingsEntity.defaultOf(from: storage, title: "Курсы")
        
        return [incomeTileSettings, outcomeTileSettings, coursesTileSettings].compactMap { $0 }
    }
    
    public func getAllTileSettings() -> [any TileSettingsProtocol] {
        
        var tileSettings: [any TileSettingsProtocol] = storage.fetch(type: CoinActionTileSettingsEntity.self)
        storage.fetch(type: CurrencyRateTileSettingsEntity.self).forEach { tileSettings.append($0) }
        
        if tileSettings.count < 1 {
            return defaultTileSettings
        }
        
        return tileSettings
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
