//
//  TileCollectionViewController.swift
//  coin control
//
//  Created by Stepan Konashenko on 21.10.2023.
//

import UIKit

private let reuseIdentifier = "Cell"

typealias TileView = TileProtocol & UIView

// MARK: - TileCollectionViewControllerProtocol
public protocol TileCollectionViewControllerProtocol: AnyObject {
    
    var presenter: TileCollectionPresenterProtocol? { get set }
    func displayTile(tile: TileProtocol)
}

// MARK: - TileCollectionViewController

public class TileCollectionViewController: UICollectionViewController, TileCollectionViewControllerProtocol {
    
    private var tiles = [TileView]()
    public var presenter: TileCollectionPresenterProtocol?
    
    public override func viewDidLoad() {
        
        TileCollectionAssembly().assemble(with: self)
        
        super.viewDidLoad()
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView!.backgroundColor = MainDefaultColors.background.getUIColor()
        
        presenter?.viewDidLoad()
        
        print("DEBUG: displayed main view")
    }

    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection: Int) -> Int {
        tiles.count
    }

    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let tile = tiles[indexPath.row]
        cell.addSubview(tile)
        
        NSLayoutConstraint.activate([
            tile.topAnchor.constraint(equalTo: cell.topAnchor),
            tile.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
            tile.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            tile.widthAnchor.constraint(equalTo: cell.widthAnchor),
        ])
        
        return cell
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: view.frame.width / 2 - 20, height: 150)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 5
        
        return layout
    }
    
    public func displayTile(tile: TileProtocol) {
        
        if let coinActionTile = tile as? CoinActionTileView {
                        
            let longPressGestureRecognizer = UILongPressGestureRecognizer(target: coinActionTile, action: #selector(coinActionTile.longPress))
            
            longPressGestureRecognizer.minimumPressDuration = 1
            coinActionTile.addGestureRecognizer(longPressGestureRecognizer)
            
            tiles.append(coinActionTile)
        }
    }
}

// MARK: - CoinIncomeTile

fileprivate extension CoinActionTileView {
    
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
