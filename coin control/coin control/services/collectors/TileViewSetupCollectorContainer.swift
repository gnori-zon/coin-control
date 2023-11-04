//
//  TileViewSetupCollectorContainer.swift
//  coin control
//
//  Created by Stepan Konashenko on 02.11.2023.
//

// MARK: - TileViewSetupCollectorContainerProtocol

public protocol TileViewSetupCollectorContainerProtocol {
    
    func loadAllSetups() -> [() -> any TileProtocol]
}

// MARK: - TileViewSetupCollectorContainer

public struct TileViewSetupCollectorContainer: TileViewSetupCollectorContainerProtocol {
    
    private var storage: some StorageServiceProtocol = StorageService.shared()
    private var tileSettingsService: TileSettingsServiceProtocol
    
    init (_ tileSettingsService: TileSettingsServiceProtocol) {
        self.tileSettingsService = tileSettingsService
    }
    
    public func loadAllSetups() -> [() -> any TileProtocol] {
        
        let tileSettings = self.tileSettingsService.getAllTileSettings()
        let coinActions = Dictionary(grouping: storage.fetch(type: CoinActionEntity.self), by: { $0.actionType })
        
        return tileSettings.compactMap { tileSettingRaw in
            
            if let tileSetting = tileSettingRaw as? CoinActionTileSettingsEntity {
                return CoinActionTileViewSetupCollector(raw: coinActions).collect(for: tileSetting)
                
            } else if let tileSetting = tileSettingRaw as? CurrencyRateTileSettingsEntity {
                return CurrencyRateTileViewSetupCollector().collect(for: tileSetting)
            }
            
            return nil
        }
    }
}
