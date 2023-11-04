//
//  TileCollectionPresenter.swift
//  coin control
//
//  Created by Stepan Konashenko on 22.10.2023.
//

public protocol TileCollectionPresenterProtocol: AnyObject {
    func viewDidLoad()
    func tilesDidLoad(tiles: [any TileProtocol])
}

public class TileCollectionPresenter: TileCollectionPresenterProtocol {
    
    weak var viewController: TileCollectionViewControllerProtocol?
    let router: TileCollectionRouterProtocol
    let interactor: TileCollectionInteractorProtocol
    
    init(router: TileCollectionRouterProtocol, interactor: TileCollectionInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    public func viewDidLoad() {
        interactor.loadTiles()
    }
    
    public func tilesDidLoad(tiles: [any TileProtocol]) {
        
        viewController?.clearTiles()
        tiles.forEach { viewController?.addTile(tile: $0) }
        viewController?.reloadData()
    }
}
