//
//  CoinActionTileViewCollector.swift
//  coin control
//
//  Created by Stepan Konashenko on 02.11.2023.
//

public struct CoinActionTileViewCollector: TileViewCollectorProtocol {
    
    private var storage: some StorageServiceProtocol = StorageService.shared()

    public func castedCollectSetups(for tileSetting: CoinActionTileSettingsEntity) -> () -> any TileProtocol {
        
        return {
            
            let rawData = Dictionary(grouping: storage.fetch(type: CoinActionEntity.self), by: { $0.actionType })
            
            let tileView = CoinActionTileView(tileSetting.id, records: rawData.convertToRecords(by: tileSetting.coinActionType))
            tileView.setup(title: tileSetting.title)
            
            return tileView
        }
    }
    
    public func castedCollectReplacer(for tileSetting: CoinActionTileSettingsEntity) -> (any TileProtocol) -> Void {
        
        return { tileView in
            
            guard let coinActionTileView = tileView as? CoinActionTileView else {
                print("DEBUG: bad find tile view | expected:\(CoinActionTileView.self) | actual: \(tileView.self)")
                return
            }
            let rawData = Dictionary(grouping: storage.fetch(type: CoinActionEntity.self), by: { $0.actionType })

            coinActionTileView.records = rawData.convertToRecords(by: tileSetting.coinActionType)
        }
    }
}

fileprivate extension Dictionary where Key == CoinActionType, Value == [CoinActionEntity] {
    
    func convertToRecords(by coinActionType: CoinActionType) -> [String] {
        
        var records = [String]()
        let maxItems = 5
        var currentCount = 0
        
        for incomeItem in self[coinActionType]?.reversed() ?? [] {
            
            currentCount += 1
            if currentCount > maxItems {
                break
            }
            
            records.append("\(incomeItem.value) \(incomeItem.currencyType.currencyRaw.str)")
        }
        
        return records
    }
}
