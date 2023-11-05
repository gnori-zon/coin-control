//
//  TileViewCollectorContainer.swift
//  coin control
//
//  Created by Stepan Konashenko on 02.11.2023.
//

// MARK: - TileViewSetupCollectorContainerProtocol

public protocol TileViewCollectorContainerProtocol {
    
    func loadAllSetups() -> [() -> any TileProtocol]
    func loadAllReplacers(for tileSettingsType: TileSettingsType) -> [(id: String, action: (any TileProtocol) -> Void)]
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
            
            return findCollector(by: tileSettingRaw)?.collectSetups(for: tileSettingRaw)
        }
    }
    
    public func loadAllReplacers(for tileSettingsType: TileSettingsType) -> [(id: String, action: (any TileProtocol) -> Void)] {
        
        var tileContents = [(String, (any TileProtocol) -> Void)]()
        let tileSettings = self.tileSettingsService.getAllTileSettings(type: tileSettingsType.entityType)

        tileSettings.forEach { tileSettingRaw in
            
            if let replacer = findCollector(by: tileSettingRaw)?.collectReplacer(for: tileSettingRaw) {
                
                tileContents.append((tileSettingRaw.id, replacer))
            }
        }
        
        return tileContents
    }
    
    private func findCollector<T: TileSettingsEntityProtocol>(by object: T) -> (any TileViewCollectorProtocol)? {
        
        guard let type = TileSettingsType.of(object) else {
            return nil
        }
        
        return collectors[type]
    }
}
