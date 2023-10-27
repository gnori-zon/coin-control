//
//  CoinActionWriterPresenter.swift
//  coin control
//
//  Created by Stepan Konashenko on 27.10.2023.
//

import UIKit

public protocol CoinActionWriterPresenterProtocol: AnyObject {
    
    func viewDidLoad()
}

public class CoinActionWriterPresenter: CoinActionWriterPresenterProtocol {
    
    weak var viewController: CoinActionWriterViewControllerProtocol?
    let router: CoinActionWriterRouterProtocol
    let interactor: CoinActionWriterInteractorProtocol
    
    init(router: CoinActionWriterRouterProtocol, interactor: CoinActionWriterInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    public func viewDidLoad() {
        
    }
    
}
