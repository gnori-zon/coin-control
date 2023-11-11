//
//  DaoServiceFactory.swift
//  coin control
//
//  Created by Stepan Konashenko on 11.11.2023.
//

import Foundation

public final class DaoServiceFactory {
    
    static let shared = DaoServiceFactory(CurrencyRateService(), CoinActionService(), TileSettingsService())
    
    let currencyRateService: CurrencyRateServiceProtocol
    let coinActionService: CoinActionServiceProtocol
    let tileSettingsService: TileSettingsServiceProtocol
    
    private init (
        _ currencyRateService: CurrencyRateServiceProtocol,
        _ coinActionService: CoinActionServiceProtocol,
        _ tileSettingsService: TileSettingsServiceProtocol
    ) {
        
        self.currencyRateService = currencyRateService
        self.coinActionService = coinActionService
        self.tileSettingsService = tileSettingsService
    }
    
    public func findDaoService<T>(type: T.Type) -> T? {
        
        if type == CurrencyRateServiceProtocol.self {
            return currencyRateService as? T
        }
        
        if type == CoinActionServiceProtocol.self {
            return coinActionService as? T
        }
        
        if type == TileSettingsServiceProtocol.self {
            return tileSettingsService as? T
        }
        
        return nil
    }
}
