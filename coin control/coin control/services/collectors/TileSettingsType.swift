//
//  TileSettingsType.swift
//  coin control
//
//  Created by Stepan Konashenko on 05.11.2023.
//

public enum TileSettingsType {
    case coinAction, currencyRate
    
    static func of(_ object: any InstanceTileSettingsEntityProtocol) -> TileSettingsType? {
        
        if object is CoinActionTileSettingsEntity {
            return .coinAction
        }
        
        if object is CurrencyRateTileSettingsEntity {
            return .currencyRate
        }
        
        return nil
    }
    
    var entityType: any InstanceTileSettingsEntityProtocol.Type {
        
        switch self {
        case .coinAction:
            return CoinActionTileSettingsEntity.self
        case .currencyRate:
            return CurrencyRateTileSettingsEntity.self
        }
    }
}
