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
    private let tileViewCollectorContainer: TileViewSetupCollectorContainerProtocol
    
    init(_ tileViewCollectorContainer: TileViewSetupCollectorContainerProtocol) {
        self.tileViewCollectorContainer = tileViewCollectorContainer
    }
    
    public func loadRawTiles() {
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            
            let setups = tileViewCollectorContainer.loadAllSetups()
            
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
