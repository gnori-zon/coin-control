//
//  TileSettingsType.swift
//  coin control
//
//  Created by Stepan Konashenko on 05.11.2023.
//

typealias CollectorParameter<T> = (type: TileSettingsType, instance: T)

public enum TileSettingsType {
    case coinAction, currencyRate
    
    static func collectorParameterOf<T: TileSettingsEntityProtocol>(_ rawObject: T) -> CollectorParameter<T>? {
        
        switch rawObject {
        case _ where rawObject is CoinActionTileSettingsEntity:
            return (.coinAction, rawObject)
        case _ where rawObject is CurrencyRateTileSettingsEntity:
            return (.currencyRate, rawObject)
            
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
