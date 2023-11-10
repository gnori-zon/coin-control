//
//  TileCollectionRouter.swift
//  coin control
//
//  Created by Stepan Konashenko on 22.10.2023.
//

import UIKit

public protocol TileCollectionRouterProtocol {
    
    func viewDidAppear()
}

public final class TileCollectionRouter: TileCollectionRouterProtocol {
    
    weak var viewController: (TileCollectionViewControllerProtocol & UIViewController)?
    
    public func viewDidAppear() {
        
        let viewControllerToPresent = CoinActionWriterViewController()
        viewControllerToPresent.initSheetPresentationController();
        
        viewController?.present(viewControllerToPresent, animated: true, completion: nil)
    }
}
