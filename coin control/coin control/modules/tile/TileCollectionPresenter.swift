//
//  TileCollectionPresenter.swift
//  coin control
//
//  Created by Stepan Konashenko on 22.10.2023.
//

import Foundation

public protocol TileCollectionPresenterProtocol: AnyObject {
    func viewDidLoad()
    func tilesDidLoad(tiles: [any TileProtocol])
    func replaceContent(for id: String, replacer: (any TileProtocol) -> Void)
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
    
    public func replaceContent(for id: String, replacer: (any TileProtocol) -> Void){
        
        guard let tileView = viewController?.findTile(by: id) else {
            print("DEBUG: not found tile by id: \(id)")
            return
        }
        
        replacer(tileView)
    }
}
