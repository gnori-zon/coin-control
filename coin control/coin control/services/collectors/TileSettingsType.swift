//
//  TileSettingsType.swift
//  coin control
//
//  Created by Stepan Konashenko on 05.11.2023.
//

public enum TileSettingsType {
    case coinAction, currencyRate
    
    static func of(_ object: any InstanceTileSettingsEntityProtocol) -> TileSettingsType? {
        
        switch object {
        case _ where object is CoinActionTileSettingsEntity:
            return .coinAction
        case _ where object is CurrencyRateTileSettingsEntity:
            return .currencyRate
            
        default:
            return nil
        }
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
