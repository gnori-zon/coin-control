//
//  CoinActionTileViewSetupCollector.swift
//  coin control
//
//  Created by Stepan Konashenko on 02.11.2023.
//

public struct CoinActionTileViewSetupCollector: TileViewSetupCollectorProtocol {
    
    private let rawData: [CoinActionType:[CoinActionEntity]]
    
    init (raw data: [CoinActionType:[CoinActionEntity]]) {
        rawData = data
    }
    
    public func collect(for tileSetting: CoinActionTileSettingsEntity) -> () -> TileProtocol {
        
        return {
            
            let tileView = CoinActionTileView()
            tileView.setup(title: tileSetting.title, records: rawData.convertToRecords(by: tileSetting.coinActionType))
            
            return tileView
        }
    }
}

fileprivate extension Dictionary where Key == CoinActionType, Value == [CoinActionEntity] {
    
    func convertToRecords(by coinActionType: CoinActionType) -> [String] {
        
        var records = [String]()
        let maxItems = 5
        var currentCount = 0
        
        for incomeItem in self[coinActionType] ?? [] {
            
            currentCount += 1
            if currentCount >= maxItems {
                break
            }
            
            records.append("\(incomeItem.value) \(incomeItem.currencyType.currencyRaw.str)")
        }
        
        return records
    }
}
