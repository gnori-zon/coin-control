//
//  TileViewCollectorContainer.swift
//  coin control
//
//  Created by Stepan Konashenko on 02.11.2023.
//

// MARK: - TileViewSetupCollectorContainerProtocol

public typealias TileAction = (id: String, action: (any TileProtocol) -> Void)

public protocol TileViewCollectorContainerProtocol {
    
    func loadAllSetups() -> [() -> any TileProtocol]
    func loadAllReplacers(for tileSettingsType: TileSettingsType, tileFilters: [FilterEntities]) -> [TileAction]
}

// MARK: - TileViewCollectorContainer

public struct TileViewCollectorContainer: TileViewCollectorContainerProtocol {
    
    private var tileSettingsService: TileSettingsServiceProtocol
    
    init (_ tileSettingsService: TileSettingsServiceProtocol) {
        self.tileSettingsService = tileSettingsService
    }
    
    public func loadAllSetups() -> [() -> any TileProtocol] {
        
        let tileSettings = self.tileSettingsService.getAllTileSettings()
        
        return tileSettings.compactMap { tileSettingRaw in
            
            guard let tileSettingsType = TileSettingsType.of(tileSettingRaw) else {
                return nil
            }
            
            switch tileSettingsType {
            case .coinAction:
                return CoinActionTileViewCollector().collectSetups(for: tileSettingRaw as! CoinActionTileSettingsEntity)
            case .currencyRate:
                return CurrencyRateTileViewCollector().collectSetups(for: tileSettingRaw as! CurrencyRateTileSettingsEntity)
            }
        }
    }
    
    public func loadAllReplacers(for tileSettingsType: TileSettingsType, tileFilters: [FilterEntities]) -> [TileAction] {
        
        let tileSettings = self.tileSettingsService.getAllTileSettings(type: tileSettingsType.entityType, tileFilters: tileFilters)
        
        return tileSettings.map { tileSettingRaw in
            
            let replacer: (any TileProtocol) -> Void
            
            switch tileSettingsType {
            case .coinAction:
                replacer = CoinActionTileViewCollector().castedCollectReplacer(for: tileSettingRaw as! CoinActionTileSettingsEntity)
            case.currencyRate:
                replacer = CurrencyRateTileViewCollector().castedCollectReplacer(for: tileSettingRaw as! CurrencyRateTileSettingsEntity)
            }
            
            return (tileSettingRaw.id, replacer)
        }
    }
}
