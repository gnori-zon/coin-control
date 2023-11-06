//
//  CoinActionTileViewCollector.swift
//  coin control
//
//  Created by Stepan Konashenko on 02.11.2023.
//

public struct CoinActionTileViewCollector: TileViewCollectorProtocol {
    
    private var storage: some StorageServiceProtocol = StorageService.shared()

    public func collectSetups(for tileSetting: CoinActionTileSettingsEntity) -> () -> any TileProtocol {
        
        let rawData = getData(by: tileSetting)
        let records = rawData.convertToRecords()
        
        return {
        
            let tileView = CoinActionTileView(tileSetting.id, records: records)
            tileView.setup(title: tileSetting.title)
            
            return tileView
        }
    }
    
    public func collectReplacer(for tileSetting: CoinActionTileSettingsEntity) -> (any TileProtocol) -> Void {

        let rawData = getData(by: tileSetting)
        let records = rawData.convertToRecords()
        
        return { tileView in
            
            guard let coinActionTileView = tileView as? CoinActionTileView else {
                print("DEBUG: bad find tile view | expected:\(CoinActionTileView.self) | actual: \(tileView.self)")
                return
            }
            
            coinActionTileView.records = records
        }
    }
    
    private func getData(by entity: CoinActionTileSettingsEntity) -> [CoinActionEntity] {
        
        let filter: FilterEntity = (field: .actionTypeCode, sign: .equals, value: entity.coinActionType.rawValue)
        let sorting: SortingEntity = (type: entity.sortingType, direction: entity.sortingDirection)
        
        return storage.fetch(type: CoinActionEntity.self, where: [filter], orderBy: [sorting])
    }
}

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
