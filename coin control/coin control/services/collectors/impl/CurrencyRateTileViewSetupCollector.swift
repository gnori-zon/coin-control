//
//  CurrencyRateTileViewSetupCollector.swift
//  coin control
//
//  Created by Stepan Konashenko on 02.11.2023.
//

public struct CurrencyRateTileViewSetupCollector: TileViewSetupCollectorProtocol {
    
    public func collect(for tileSetting: CurrencyRateTileSettingsEntity) -> () -> TileProtocol {
        
        return {
            // TODO: replace this mock
            let tileView = CurrencyRateTileView(tileSetting.id, records: [
                (imagePath: CurrencyType.eur.currencyRaw.imagePath, text: "103 rub"),
                (imagePath: CurrencyType.usd.currencyRaw.imagePath, text: "97 rub")
            ])
            tileView.setup(title: "Курсы", timeUpdate: "12:12")
            
            return tileView
        }
    }
}
