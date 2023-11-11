//
//  TileCollectionPresenter.swift
//  coin control
//
//  Created by Stepan Konashenko on 22.10.2023.
//

import Foundation

public protocol TileCollectionPresenterProtocol: AnyObject {
    
    func viewDidAppear()
    func tilesDidLoad(tiles: [TileProtocol])
    func replaceContent(for id: String, replacer: (TileProtocol) -> Void)
}

// MARK: - TileCollectionPresenter

public final class TileCollectionPresenter: TileCollectionPresenterProtocol {
    
    weak var viewController: TileCollectionViewControllerProtocol?
    let router: TileCollectionRouterProtocol
    let interactor: TileCollectionInteractorProtocol
    
    init(router: TileCollectionRouterProtocol, interactor: TileCollectionInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    public func viewDidAppear() {
        
        interactor.loadTiles()
        router.viewDidAppear()
    }
    
    public func tilesDidLoad(tiles: [TileProtocol]) {
        
        viewController?.clearTiles()
        tiles.forEach { viewController?.addTile(tile: $0) }
        viewController?.reloadData()
    }
    
    public func replaceContent(for id: String, replacer: (TileProtocol) -> Void){
        
        guard let tileView = viewController?.findTile(by: id) else {
            print("DEBUG: not found tile by id: \(id)")
            return
        }
        
        replacer(tileView)
    }
}
