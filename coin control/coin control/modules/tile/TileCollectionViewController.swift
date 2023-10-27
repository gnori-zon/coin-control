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
    func addTile(tile: TileProtocol)
    func reloadData()
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
    
    public override func viewDidAppear(_ animated: Bool) {
        showCoinActionWriterViewControllerInCustomizedSheet()
    }
    
    public func addTile(tile: TileProtocol) {
        
        switch tile {
        case _ where tile is CoinActionTileView:
            displayCoinActionTileView(tile: tile as! CoinActionTileView)
        case _ where tile is CurrencyRateTileView:
            tiles.append(tile as! CurrencyRateTileView)
        
        default:
            print("DEBUG: receive unknown tile")
        }
    }
    
    public func reloadData() {
        self.collectionView.reloadData()
    }
    
    private func displayCoinActionTileView(tile: CoinActionTileView) {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: tile, action: #selector(tile.longPress))
        
        longPressGestureRecognizer.minimumPressDuration = 1
        tile.addGestureRecognizer(longPressGestureRecognizer)
        
        tiles.append(tile)
    }
}

//MARK: - methods CollectionViewController
public extension TileCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection: Int) -> Int {
        tiles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 5
        
        return layout
    }
}

// MARK: - CoinActionTileView

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

//MARK: - show CoinActionWriterViewController (may be move to Router?)

fileprivate extension TileCollectionViewController {
    
    func showCoinActionWriterViewControllerInCustomizedSheet() {
        
        let viewControllerToPresent = CoinActionWriterViewController()
        
        if let sheet = viewControllerToPresent.sheetPresentationController {
            
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = true
        }
        
        present(viewControllerToPresent, animated: true, completion: nil)
    }
}
