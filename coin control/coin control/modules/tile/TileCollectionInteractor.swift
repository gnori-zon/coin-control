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

public final class TileCollectionInteractor: TileCollectionInteractorProtocol {

    weak var presenter: TileCollectionPresenterProtocol?
    private let tileViewCollectorContainer: TileViewCollectorContainerProtocol
    
    init(_ tileViewCollectorContainer: TileViewCollectorContainerProtocol) {
        self.tileViewCollectorContainer = tileViewCollectorContainer
        NotificationCenter.default.addObserver(self, selector: #selector(didAddCoinAction), name: .didAddCoinAction, object: nil)
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
        
    @objc private func didAddCoinAction(_ notification: Notification) {
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            
            guard let coinActionType = notification.object as? CoinActionType else {
                print("DEBUG: receive undefined 'didAddCoinAction' notification")
                return
            }
            
            let filter: FilterEntities = (field: .coinActionTypeCode, sign: .equals, value: coinActionType.rawValue)
            let replacers = self.tileViewCollectorContainer.loadAllReplacers(for: .coinAction, tileFilters: [filter])
            
            replacers.forEach { replacer in
                
                self.presenter?.replaceContent(for: replacer.id) { tileView in
                    
                    replacer.action(tileView)
                    
                    DispatchQueue.main.async {
                        tileView.reloadContent()
                    }
                }
            }
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
