//
//  CoinActionWriterRouter.swift
//  coin control
//
//  Created by Stepan Konashenko on 27.10.2023.
//

import Foundation

// MARK: - CoinActionWriterRouterProtocol

public protocol CoinActionWriterRouterProtocol {
    
}

// MARK: - CoinActionWriterRouter

public class CoinActionWriterRouter: CoinActionWriterRouterProtocol {
    
    weak var viewController: CoinActionWriterViewControllerProtocol?
}
