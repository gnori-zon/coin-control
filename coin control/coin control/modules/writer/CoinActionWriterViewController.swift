//
//  CoinActionWriterViewController.swift
//  coin control
//
//  Created by Stepan Konashenko on 27.10.2023.
//

import UIKit

//MARK: - CoinActionWriterViewControllerProtocol

public protocol CoinActionWriterViewControllerProtocol: AnyObject {
    
    var presenter: CoinActionWriterPresenterProtocol? { get set }
}

//MARK: - CoinActionWriterViewController

public final class CoinActionWriterViewController: UIViewController, CoinActionWriterViewControllerProtocol {
    
    public var presenter: CoinActionWriterPresenterProtocol?
    
    public override func loadView() {
        view = createCoinActionWriterView()
    }
    
    public override func viewDidLoad() {
        
        CoinActionWriterAssembly.assemble(with: self)
        applyWriterViewHandlers()
        print("DEBUG: displayed bottom sheet view")
    }
    
    private func createCoinActionWriterView() -> CoinActionWriterView {
        
        let writerView = CoinActionWriterView()
        writerView.setup(
            title: "Укажите активность",
            confirmButtonTitle: "Добавить",
            currencyValues: CurrencyType.validCases,
            actionValues: CoinActionType.validCases
            
        )
    
        return writerView
    }
    
    private func applyWriterViewHandlers() {
        
        guard let writerView = view as? CoinActionWriterView else {
            return
        }
        
        writerView.valueValidator = TextFieldDecimalValidator.validate
        writerView.confirmHandler = presenter?.getConfirmHandler()
    }
    
}

//MARK: - initSheetPresentationController

public extension CoinActionWriterViewController {
    
    func initSheetPresentationController() {
        
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
