//
//  TileCollectionPresenter.swift
//  coin control
//
//  Created by Stepan Konashenko on 22.10.2023.
//

public protocol TileCollectionPresenterProtocol: AnyObject {
    func viewDidLoad()
    func tilesDidLoad(tiles: [TileProtocol])
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
    
    public func tilesDidLoad(tiles: [TileProtocol]) {
        
        tiles.forEach {tile in
            viewController?.addTile(tile: tile)
        }
        
        viewController?.reloadData()
    }
}
