//
//  CoinActionWriterAssembly.swift
//  coin control
//
//  Created by Stepan Konashenko on 27.10.2023.
//

import UIKit

// MARK: - CoinActionWriterAssemblyProtocol

public protocol CoinActionWriterAssemblyProtocol {
    
    static func assemble(with viewController: CoinActionWriterViewControllerProtocol)
}

// MARK: - CoinActionWriterAssembly

public struct CoinActionWriterAssembly: CoinActionWriterAssemblyProtocol {
        
    public static func assemble(with viewController: CoinActionWriterViewControllerProtocol) {
        
        let coinActionService = DaoServiceFactory.shared.findDaoService(type: CoinActionServiceProtocol.self)!

        let interactor = CoinActionWriterInteractor(coinActionService)
        let router = CoinActionWriterRouter()
        let presenter = CoinActionWriterPresenter(router: router, interactor: interactor)
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        interactor.presenter = presenter
        router.viewController = viewController
    }
}
