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

public protocol NotificationReceiverProtocol {
    func receiveNotification(_ notification: Notification)
}

public final class TileCollectionInteractor: TileCollectionInteractorProtocol {
    
    weak var presenter: TileCollectionPresenterProtocol?
    private let tileViewCollectorContainer: TileViewCollectorContainerProtocol
    
    init(_ tileViewCollectorContainer: TileViewCollectorContainerProtocol) {
        
        self.tileViewCollectorContainer = tileViewCollectorContainer
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveNotification),
            name: .didAddCoinAction,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveNotification),
            name: .didUpdateCurrencyRates,
            object: nil
        )
    }
    
    public func loadTiles() {
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            
            let setups = tileViewCollectorContainer.loadAllSetups()
            
            DispatchQueue.main.async { [unowned self] in
                
                let tileViews = applySetups(setups).peek { addGestureIfView(for: $0) }
                presenter?.tilesDidLoad(tiles: tileViews)
            }
        }
    }
    
    private func applySetups(_ setups: [() -> TileProtocol]) -> [TileProtocol] {
        return setups.map { $0() }
    }
    
    private func addGestureIfView(for tile: TileProtocol) {
        
        if let view = tile as? UIView {
            
            let longPressGestureRecognizer = UILongPressGestureRecognizer(target: view, action: #selector(view.longPress))
            
            longPressGestureRecognizer.minimumPressDuration = 1
            view.addGestureRecognizer(longPressGestureRecognizer)
        }
    }
}

// MARK: - NotificationReceiverProtocol

extension TileCollectionInteractor: NotificationReceiverProtocol {
    
    @objc public func receiveNotification(_ notification: Notification) {
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            
            loadReplacers(for: notification).forEach { replacer in
                
                presenter?.replaceContent(for: replacer.id) { tileView in
                    
                    replacer.action(tileView)
                    DispatchQueue.main.async { tileView.reloadContent() }
                }
            }
        }
    }
    
    private func loadReplacers(for notification: Notification) -> [TileAction] {
        
        switch notification.name {
        case .didAddCoinAction:
            return loadReplacersForCoinActions(notification)
        case .didUpdateCurrencyRates:
            return loadReplacersForCurrencyRates(notification)
        default:
            return []
        }
    }
    
    private func loadReplacersForCurrencyRates(_ notification: Notification) -> [TileAction] {
        
        guard let currencyRateTypes = notification.object as? [CurrencyType] else {
            print("DEBUG: receive undefined 'didUpdateCurrencyRates' notification")
            return []
        }
        
        let filters = currencyRateTypes.map { FilterEntity(field: .selectedCurrencyCodes, sign: .like, value: "'*\($0.rawValue)*'") }
        let compoundFilterEntity = CompoundFilterEntity(filters: filters, joiner: .or)
        
        return  tileViewCollectorContainer.loadAllReplacers(for: .currencyRate, filtering: compoundFilterEntity)
    }
    
    private func loadReplacersForCoinActions(_ notification: Notification) -> [TileAction] {
        
        guard let coinActionType = notification.object as? CoinActionType else {
            print("DEBUG: receive undefined 'didAddCoinAction' notification")
            return []
        }
        
        let filter = FilterEntity(field: .coinActionTypeCode, sign: .equals, value: coinActionType.rawValue)
        let compoundFilterEntity = CompoundFilterEntity(filters: [filter], joiner: .and)
        
        return tileViewCollectorContainer.loadAllReplacers(for: .coinAction, filtering: compoundFilterEntity)
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
        UIView.animate(withDuration: 0.2) { [unowned self] in

            transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    func identitySize() {
        UIView.animate(withDuration: 0.1) { [unowned self] in

            transform = CGAffineTransform.identity
        }
    }
}
