//
//  TileCollectionInteractor.swift
//  coin control
//
//  Created by Stepan Konashenko on 22.10.2023.
//

import UIKit

public protocol TileCollectionInteractorProtocol {
    func loadTiles()
}

public class TileCollectionInteractor: TileCollectionInteractorProtocol {

    weak var presenter: TileCollectionPresenterProtocol?
    private let tileViewCollectorContainer: TileViewSetupCollectorContainerProtocol
    
    init(_ tileViewCollectorContainer: TileViewSetupCollectorContainerProtocol) {
        self.tileViewCollectorContainer = tileViewCollectorContainer
    }
    
    public func loadTiles() {
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            
            let setups = tileViewCollectorContainer.loadAllSetups()
            
            DispatchQueue.main.async { [unowned self] in
                
                let tileViews = self.applySetups(setups).peek { self.addGestureIfView(for: $0) }
                self.presenter?.tilesDidLoad(tiles: tileViews)
            }
        }
    }
    
    private func applySetups(_ setups: [() -> any TileProtocol]) -> [any TileProtocol] {
        
        return setups.map { $0() }
    }
    
    private func addGestureIfView(for tile: any TileProtocol) {
        
        if let view = tile as? UIView {
            
            let longPressGestureRecognizer = UILongPressGestureRecognizer(target: view, action: #selector(view.longPress))

            longPressGestureRecognizer.minimumPressDuration = 1
            view.addGestureRecognizer(longPressGestureRecognizer)
        }
    }
}

// MARK: peek Array

public extension Array {
    
    func peek(_ action: (Element) -> Void) -> [Element] {

        return self.map { element in
            
            action(element)
            return element
        }
    }
}

//MARK: UILongPressGestureRecognizer

fileprivate extension UIView {
    
    @objc func longPress(sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .began:
            compressSize()
        case .ended:
            identitySize()
        default:
            return
        }
    }
    
    func compressSize() {
        UIView.animate(withDuration: 0.2, animations: { self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8) })
    }
    
    func identitySize() {
        UIView.animate(withDuration: 0.1, animations: { self.transform = CGAffineTransform.identity })
    }
}
