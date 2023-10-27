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
    
    public func loadRawTiles() {
        
        let tiles = loadMockTiles()
        presenter?.tilesDidLoad(tiles: tiles)
        
    }
    
    private func loadMockTiles() -> [TileProtocol] {
        
        let tile1 = CoinActionTileView()
        tile1.setup(title: "Траты", records: ["1. 50 rub", "2. 140 usd", "3. 122 rub", "4. 11 rub"])
        
        let tile2 = CoinActionTileView()
        tile2.setup(title: "Прибыль", records: ["1. 530 rub", "2. 10 usd", "3. 12 rub", "4. 111 rub"])
        
        let tile3 = CurrencyRateTileView()
        tile3.setup(title: "Курсы", timeUpdate: "12:12", records: [
            (imagePath: CurrencyType.eur.currencyRaw.imagePath, text: "103 rub"),
            (imagePath: CurrencyType.usd.currencyRaw.imagePath, text: "97 rub")
        ])
        
        return [tile1, tile2, tile3]
    }
}
