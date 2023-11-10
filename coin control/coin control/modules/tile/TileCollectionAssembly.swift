//
//  TileCollectionAssembly.swift
//  coin control
//
//  Created by Stepan Konashenko on 22.10.2023.
//

import UIKit

public protocol TileCollectionAssemblyProtocol {
    
    func assemble(with viewController: TileCollectionViewControllerProtocol & UIViewController)
}

// MARK: TileCollectionAssembly

public struct TileCollectionAssembly: TileCollectionAssemblyProtocol {
   
    public func assemble(with viewController: TileCollectionViewControllerProtocol & UIViewController) {
        
        let daoServiceFactory = DaoServiceFactory.shared
        let tileSettingsService = daoServiceFactory.findDaoService(type: TileSettingsServiceProtocol.self)!
        let coinActionService = daoServiceFactory.findDaoService(type: CoinActionServiceProtocol.self)!
        let currencyRateService = daoServiceFactory.findDaoService(type: CurrencyRateServiceProtocol.self)!
        let container = TileViewCollectorContainer(tileSettingsService, coinActionService, currencyRateService)
        
        let interactor = TileCollectionInteractor(container)
        let router = TileCollectionRouter()
        let presenter = TileCollectionPresenter(router: router, interactor: interactor)
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        interactor.presenter = presenter
        router.viewController = viewController
    }
}
