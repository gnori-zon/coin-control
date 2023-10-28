//
//  CoinActionWriterViewController.swift
//  coin control
//
//  Created by Stepan Konashenko on 27.10.2023.
//

import UIKit

public protocol CoinActionWriterViewControllerProtocol: AnyObject {
    
    var presenter: CoinActionWriterPresenterProtocol? { get set }
}


public class CoinActionWriterViewController: UIViewController, CoinActionWriterViewControllerProtocol {
    
    public var presenter: CoinActionWriterPresenterProtocol?
    
    public override func viewDidLoad() {
        
        CoinActionWriterAssembly.assemble(with: self)
        
        view.backgroundColor = TileDefaultColors.background.getUIColor()
        title = "Укажите активность"
        
        presenter?.viewDidLoad()
        
        print("DEBUG: displayed bottom sheet view")
    }
    
    public func initSheetPresentationController() {
        
        isModalInPresentation = true
        
        if let sheet = sheetPresentationController {
            
            sheet.detents = [.medium(), .low()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = true
        }
    }
}

//MARK: - CUSTOM UISheetPresentationController.Detent

fileprivate typealias Detent = UISheetPresentationController.Detent

fileprivate extension Detent {
    
    static func low() -> Detent {
        
        Detent.custom(identifier: Detent.Identifier.init("low")) { context in
            return context.maximumDetentValue / 12
        }
    }
}
