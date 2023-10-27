//
//  CoinActionWriterAssembly.swift
//  coin control
//
//  Created by Stepan Konashenko on 27.10.2023.
//

import UIKit

public protocol CoinActionWriterAssemblyProtocol {
    
    static func assemble(with viewController: CoinActionWriterViewControllerProtocol)
}

public class CoinActionWriterAssembly: CoinActionWriterAssemblyProtocol {
    
    public static func assemble(with viewController: CoinActionWriterViewControllerProtocol) {
        
        let interactor = CoinActionWriterInteractor()
        let router = CoinActionWriterRouter()
        let presenter = CoinActionWriterPresenter(router: router, interactor: interactor)
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        interactor.presenter = presenter
        router.viewController = viewController
    }
}
