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
}
