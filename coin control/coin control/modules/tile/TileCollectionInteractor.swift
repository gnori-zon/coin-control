//
//  TileCollectionInteractor.swift
//  coin control
//
//  Created by Stepan Konashenko on 22.10.2023.
//

import Foundation

public protocol TileCollectionInteractorProtocol {
    func loadRawTiles()
}

public class TileCollectionInteractor: TileCollectionInteractorProtocol {

    weak var presenter: TileCollectionPresenterProtocol?
    private var storage: some StorageServiceProtocol = StorageService.shared()
    private var tileSettingsService: TileSettingsServiceProtocol
    
    init(_ tileSettingsService: TileSettingsServiceProtocol) {
        self.tileSettingsService = tileSettingsService
    }
    
    public func loadRawTiles() {
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            
            let tileSettings = self.tileSettingsService.getAllTileSettings()
            let coinActions = Dictionary.init(grouping: storage.fetch(type: CoinActionEntity.self), by: { $0.actionType })
            var setups = [() -> TileProtocol]()
            
            for tileSetting in tileSettings {
                
                if let tile = tileSetting as? CoinActionTileSettingsEntity {
                    setups.append({
                        
                        let tileView = CoinActionTileView()
                        tileView.setup(title: tile.title, records: coinActions.convertToRecords(by: tile.coinActionType))
                        
                        return tileView
                    })
                    
                }
            }
            
            // create raw not released yet
           
            setups.append({
                
                let tileView = CurrencyRateTileView()
                tileView.setup(title: "Курсы", timeUpdate: "12:12", records: [
                    (imagePath: CurrencyType.eur.currencyRaw.imagePath, text: "103 rub"),
                    (imagePath: CurrencyType.usd.currencyRaw.imagePath, text: "97 rub")
                ])
                
                return tileView
            })
            
            DispatchQueue.main.async { [unowned self] in
                let tileViews = self.applySetups(setups)
                self.presenter?.tilesDidLoad(tiles: tileViews)
            }
        }
    }
    
    private func applySetups(_ setups: [() -> TileProtocol]) -> [TileProtocol] {
        
        return setups.map { $0() }
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
