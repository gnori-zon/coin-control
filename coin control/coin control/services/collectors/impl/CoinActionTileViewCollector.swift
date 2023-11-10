//
//  CoinActionTileViewCollector.swift
//  coin control
//
//  Created by Stepan Konashenko on 02.11.2023.
//

public struct CoinActionTileViewCollector: TileViewCollectorProtocol {
    
    let coinActionService: CoinActionServiceProtocol
    
    public func collectSetups(for tileSetting: CoinActionTileSettingsEntity) -> () -> any TileProtocol {
        
        let coinActions = coinActionService.getAll(for: tileSetting)
        let records = coinActions.convertToRecords()
        
        return {
        
            let tileView = CoinActionTileView(tileSetting.id, records: records)
            tileView.setup(title: tileSetting.title)
            
            return tileView
        }
    }
    
    public func collectReplacer(for tileSetting: CoinActionTileSettingsEntity) -> (any TileProtocol) -> Void {

        let coinActions = coinActionService.getAll(for: tileSetting)
        let records = coinActions.convertToRecords()
        
        return { tileView in
            
            guard let coinActionTileView = tileView as? CoinActionTileView else {
                print("DEBUG: bad find tile view | expected:\(CoinActionTileView.self) | actual: \(tileView.self)")
                return
            }
            
            coinActionTileView.records = records
        }
    }
}

// MARK: convertToRecords()

fileprivate extension Array where Element == CoinActionEntity {
    
    func convertToRecords() -> [String] {
        
        var records = [String]()
        let maxItems = 5
        var currentCount = 0
        
        for item in self {
            
            currentCount += 1
            if currentCount > maxItems {
                break
            }
            
            records.append("\(item.value) \(item.currencyType.currencyRaw.str)")
        }
        
        return records
    }
}
