//
//  CurrencyRateTileViewCollector.swift
//  coin control
//
//  Created by Stepan Konashenko on 02.11.2023.
//

import Foundation

public struct CurrencyRateTileViewCollector: TileViewCollectorProtocol {
    
    let currencyRateService: CurrencyRateServiceProtocol
    
    public func collectSetups(for tileSetting: CurrencyRateTileSettingsEntity) -> () -> any TileProtocol {
        
        let id = tileSetting.id
        let title = tileSetting.title
        let currencyRate = currencyRateService.updateAndFindLast(for: tileSetting)
        let timeUpdated = currencyRate?.date.shortFormat() ?? ""
        let records = currencyRate?.toCurrencyRateRecordRaws() ?? []
        
        return {
            
            let tileView = CurrencyRateTileView(id, records: records)
            tileView.setup(title: title, timeUpdate: timeUpdated)
            
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

//MARK: - CurrencyRateProtocol.toCurrencyRateRecordRaws, ratioCurrency.toCurrencyRateRecordRaw(), decimal.cut(), date.shortFormat()

fileprivate extension CurrencyRateProtocol {
    
    func toCurrencyRateRecordRaws() -> [CurrencyRateRecordRaw] {
        
        return self.ratioCurrencies.map { $0.toCurrencyRateRecordRaw(target: self.targetCurrencyType)
        }
    }
}

fileprivate extension RatioCurrency {
    
    func toCurrencyRateRecordRaw(target: CurrencyType) -> CurrencyRateRecordRaw {
        
        let imagePath = self.type.currencyRaw.imagePath
        let invertValue = (1 / self.value).cut(with: 2)
        
        return (imagePath: imagePath, text: "\(invertValue) \(target.currencyRaw.str)")
    }
}

extension Decimal {
    
    func cut(with offsetAfterPoint: Int) -> Double {
        
        let selfValue = self.doubleValue
        let rounder = pow(10, offsetAfterPoint).doubleValue
    
        return Double(round(selfValue * rounder) / rounder)
    }
    
    var doubleValue: Double {
        (self as NSDecimalNumber).doubleValue
    }
}

extension Date {
    
    func shortFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d.M.yyyy"
        
        return dateFormatter.string(from: self)
    }
}
