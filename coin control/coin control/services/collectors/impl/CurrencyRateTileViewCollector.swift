//
//  CurrencyRateTileViewCollector.swift
//  coin control
//
//  Created by Stepan Konashenko on 02.11.2023.
//

// TODO: replace this mock

public struct CurrencyRateTileViewCollector: TileViewCollectorProtocol {
    
    public func collectSetups(for tileSetting: CurrencyRateTileSettingsEntity) -> () -> any TileProtocol {
        
        return {
            let tileView = CurrencyRateTileView(tileSetting.id, records: [
                (imagePath: CurrencyType.eur.currencyRaw.imagePath, text: "103 rub"),
                (imagePath: CurrencyType.usd.currencyRaw.imagePath, text: "97 rub")
            ])
            tileView.setup(title: "Курсы", timeUpdate: "12:12")
            
            return tileView
        }
    }
    
    public func collectReplacer(for tileSetting: CurrencyRateTileSettingsEntity) -> (any TileProtocol) -> Void {
       
        return { tileView in
            
            guard let currencyRateTileView = tileView as? CurrencyRateTileView else {
                print("DEBUG: bad find tile view | expected:\(CurrencyRateTileView.self) | actual: \(tileView.self)")
                return
            }
            
            currencyRateTileView.currencyRateRecordRaws = [
                (imagePath: CurrencyType.eur.currencyRaw.imagePath, text: "103 rub"),
                (imagePath: CurrencyType.usd.currencyRaw.imagePath, text: "97 rub")
            ]
        }
    }
}
