//
//  TileCollectionAssembly.swift
//  coin control
//
//  Created by Stepan Konashenko on 22.10.2023.
//

import UIKit

public protocol TileCollectionAssemblyProtocol {
    
    func assemble(with viewController: TileCollectionViewControllerProtocol)
}

public struct TileCollectionAssembly: TileCollectionAssemblyProtocol {
   
    public func assemble(with viewController: TileCollectionViewControllerProtocol) {
        
        let interactor = TileCollectionInteractor(TileSettingsService())
        let router = TileCollectionRouter()
        let presenter = TileCollectionPresenter(router: router, interactor: interactor)
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        interactor.presenter = presenter
        router.viewController = viewController
    }
}
