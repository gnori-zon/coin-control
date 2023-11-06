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
    private var collectors = [TileSettingsType: any TileViewCollectorProtocol]()
    
    init (_ tileSettingsService: TileSettingsServiceProtocol) {
        self.tileSettingsService = tileSettingsService
        collectors[.coinAction] = CoinActionTileViewCollector()
        collectors[.currencyRate] = CurrencyRateTileViewCollector()
    }
    
    public func loadAllSetups() -> [() -> any TileProtocol] {
        
        let tileSettings = self.tileSettingsService.getAllTileSettings()
        
        return tileSettings.compactMap { tileSettingRaw in
            
            if let collectorParameter = TileSettingsType.collectorParameterOf(tileSettingRaw) {
                return collectors[collectorParameter.type]?.collectSetups(for: collectorParameter.instance)
            }
            return nil
        }
    }
    
    public func loadAllReplacers(for tileSettingsType: TileSettingsType, tileFilters: [FilterEntities]) -> [TileAction] {
        
        var tileContents = [TileAction]()
        let tileSettings = self.tileSettingsService.getAllTileSettings(type: tileSettingsType.entityType, tileFilters: tileFilters)

        tileSettings.forEach { tileSettingRaw in
            
            guard let collectorParameter = TileSettingsType.collectorParameterOf(tileSettingRaw) else {
                return
            }
            
            if let replacer = collectors[collectorParameter.type]?.collectReplacer(for: collectorParameter.instance) {
                tileContents.append((tileSettingRaw.id, replacer))
            }
        }
        
        return tileContents
    }
}
