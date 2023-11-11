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
    func loadAllReplacers(for tileSettingsType: TileSettingsType, filtering: CompoundFilterEntity) -> [TileAction]
}

// MARK: - TileViewCollectorContainer

public struct TileViewCollectorContainer: TileViewCollectorContainerProtocol {
    
    private let tileSettingsService: TileSettingsServiceProtocol
    private let coinActionTileViewCollector: CoinActionTileViewCollector
    private let currencyRateTileViewCollector: CurrencyRateTileViewCollector
    
    init (
        _ tileSettingsService: TileSettingsServiceProtocol,
        _ coinActionService: CoinActionServiceProtocol,
        _ currencyRateService: CurrencyRateServiceProtocol
    ) {
            
        self.tileSettingsService = tileSettingsService
        self.coinActionTileViewCollector = CoinActionTileViewCollector(coinActionService: coinActionService)
        self.currencyRateTileViewCollector = CurrencyRateTileViewCollector(currencyRateService: currencyRateService)
    }
    
    public func loadAllSetups() -> [() -> any TileProtocol] {
        
        let tileSettings = tileSettingsService.getAllTileSettings()
        
        return tileSettings.compactMap { tileSettingRaw in
            
            guard let tileSettingsType = TileSettingsType.of(tileSettingRaw) else {
                return nil
            }
            
            switch tileSettingsType {
            case .coinAction:
                return coinActionTileViewCollector.collectSetups(for: tileSettingRaw as! CoinActionTileSettingsEntity)
            case .currencyRate:
                return currencyRateTileViewCollector.collectSetups(for: tileSettingRaw as! CurrencyRateTileSettingsEntity)
            }
        }
    }
    
    public func loadAllReplacers(for tileSettingsType: TileSettingsType, filtering: CompoundFilterEntity) -> [TileAction] {
        
        let tileSettings = tileSettingsService.getAllTileSettings(type: tileSettingsType.entityType, filtering: filtering)
        
        return tileSettings.map { tileSettingRaw in
            
            let replacer: (any TileProtocol) -> Void
            
            switch tileSettingsType {
            case .coinAction:
                replacer = coinActionTileViewCollector.collectReplacer(for: tileSettingRaw as! CoinActionTileSettingsEntity)
            case.currencyRate:
                replacer = currencyRateTileViewCollector.collectReplacer(for: tileSettingRaw as! CurrencyRateTileSettingsEntity)
            }
            
            return (tileSettingRaw.id, replacer)
        }
    }
}
