//
//  TileSettingsType.swift
//  coin control
//
//  Created by Stepan Konashenko on 05.11.2023.
//

public enum TileSettingsType {
    case coinAction, currencyRate
    
    static func of(_ rawObject: Any) -> TileSettingsType? {
        
        switch rawObject {
        case _ where rawObject is CoinActionTileSettingsEntity:
            return .coinAction
        case _ where rawObject is CurrencyRateTileSettingsEntity:
            return .currencyRate
            
        default:
            print("DEBUG: undefined tileSettings type")
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
