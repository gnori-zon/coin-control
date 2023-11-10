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
        
        let currencyRate = currencyRateService.findLast(for: tileSetting)
        currencyRateService.updateCurrencyRate(for: tileSetting, onlyIfNeeded: true)
        
        let id = tileSetting.id
        let title = tileSetting.title
        let timeUpdated = currencyRate?.date.shortFormat() ?? "..."
        let records = currencyRate?.toCurrencyRateRecordRaws() ?? []
        
        return {
            
            let tileView = CurrencyRateTileView(id, records: records, timeUpdating: timeUpdated)
            tileView.setup(title: title)
            
            return tileView
        }
    }
    
    public func collectReplacer(for tileSetting: CurrencyRateTileSettingsEntity) -> (any TileProtocol) -> Void {
       
        let currencyRate = currencyRateService.findLast(for: tileSetting)
        let records: [CurrencyRateRaw] = currencyRate?.toCurrencyRateRecordRaws() ?? []
        let timeUpdated = currencyRate?.date.shortFormat() ?? "..."
        
        return { tileView in
            
            guard let currencyRateTileView = tileView as? CurrencyRateTileView else {
                print("DEBUG: bad find tile view | expected:\(CurrencyRateTileView.self) | actual: \(tileView.self)")
                return
            }
            
            currencyRateTileView.timeUpdatingText = timeUpdated
            currencyRateTileView.currencyRateRaws = records
        }
    }
}

//MARK: - toCurrencyRateRaw[s]()

fileprivate extension CurrencyRateProtocol {
    
    func toCurrencyRateRecordRaws() -> [CurrencyRateRaw] {
        
        return self.ratioCurrencies.map { $0.toCurrencyRateRecordRaw(target: self.targetCurrencyType)
        }
    }
}

fileprivate extension RatioCurrency {
    
    func toCurrencyRateRecordRaw(target: CurrencyType) -> CurrencyRateRaw {
        
        let imagePath = self.type.currencyRaw.imagePath
        let invertValue = (1 / self.value).cut(with: 2)
        
        return (imagePath: imagePath, text: "\(invertValue) \(target.currencyRaw.str)")
    }
}

// MARK: - Decimal.cut()

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

// MARK: - Date.shortFormat()
extension Date {
    
    func shortFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d.M.yyyy"
        
        return dateFormatter.string(from: self)
    }
}
