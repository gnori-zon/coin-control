//
//  TileCollectionInteractor.swift
//  coin control
//
//  Created by Stepan Konashenko on 22.10.2023.
//

import Foundation

public typealias RawTile = (title: String, records: [String])

public protocol TileCollectionInteractorProtocol {
    func loadRawTiles()
}

public class TileCollectionInteractor: TileCollectionInteractorProtocol {

    weak var presenter: TileCollectionPresenterProtocol?
    
    public func loadRawTiles() {
       
    // do load
        let rawTiles = loadMockRawTiles()
        presenter?.rawTilesDidLoad(rawTiles: rawTiles)
    }
    
    private func loadMockRawTiles() -> [RawTile] {
        [("Траты", ["1. 50 rub", "2. 140 usd", "3. 122 rub", "4. 11 rub"]),
         ("Прибыль", ["1. 530 rub", "2. 10 usd", "3. 12 rub", "4. 111 rub"])]
    }
}
