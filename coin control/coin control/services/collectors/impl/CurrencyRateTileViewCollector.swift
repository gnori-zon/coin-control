//
//  CurrencyRateTileViewCollector.swift
//  coin control
//
//  Created by Stepan Konashenko on 02.11.2023.
//

public struct CurrencyRateTileViewCollector: TileViewCollectorProtocol {
    
    let currencyRateParser: CurrencyRateParserProtocol = CurrencyRateParser(converter: CurrencyRateResponseConverter(), requestSender: HttpRequestSender())
    
    public func collectSetups(for tileSetting: CurrencyRateTileSettingsEntity) -> () -> any TileProtocol {
        
        Task.init(priority: .utility) {
            await currencyRateParser.tryParse(target: tileSetting.targetCurrencyType, ratioCurrencyTypes: tileSetting.selectedCurrencies) { currencyRate in
                // TODO: - (1) notify success by tile id and save to userDefaults (2) added temporal data from userDefaults
                print(currencyRate)
            }
        }
        
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
