//
//  CoinActionWriterPresenter.swift
//  coin control
//
//  Created by Stepan Konashenko on 27.10.2023.
//

import UIKit

// MARK: - CoinActionWriterPresenterProtocol
public protocol CoinActionWriterPresenterProtocol: AnyObject {
    
    func getConfirmHandler() -> (CoinActionType, String, CurrencyType) -> Void
}

// MARK: - CoinActionWriterPresenter

public final class CoinActionWriterPresenter: CoinActionWriterPresenterProtocol {
    
    weak var viewController: CoinActionWriterViewControllerProtocol?
    let router: CoinActionWriterRouterProtocol
    let interactor: CoinActionWriterInteractorProtocol
    
    init(router: CoinActionWriterRouterProtocol, interactor: CoinActionWriterInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    public func getConfirmHandler() -> (CoinActionType, String, CurrencyType) -> Void {
        
        return { [unowned self] actionType, value, currencyType in
            
            interactor.saveCoinAction(actionType, value, currencyType)
        }
    }
    
}
