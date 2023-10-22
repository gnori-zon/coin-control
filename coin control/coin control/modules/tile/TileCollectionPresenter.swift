//
//  TileCollectionPresenter.swift
//  coin control
//
//  Created by Stepan Konashenko on 22.10.2023.
//

public protocol TileCollectionPresenterProtocol: AnyObject {
    func viewDidLoad()
    func rawTilesDidLoad(rawTiles: [RawTile])
}

public class TileCollectionPresenter: TileCollectionPresenterProtocol {
    
    weak var viewController: TileCollectionViewControllerProtocol?
    var router: TileCollectionRouterProtocol
    var interactor: TileCollectionInteractorProtocol
    
    init(router: TileCollectionRouterProtocol, interactor: TileCollectionInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    public func viewDidLoad() {
        interactor.loadRawTiles()
    }
    
    public func rawTilesDidLoad(rawTiles: [RawTile]) {
        
        rawTiles.forEach {rawTile in
            
            let tile = CoinActionTileView()
            tile.setup(title: rawTile.title, records: rawTile.records)
            
            viewController?.displayTile(tile: tile)
        }
    }
}
