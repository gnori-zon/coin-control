//
//  TileCollectionViewController.swift
//  coin control
//
//  Created by Stepan Konashenko on 21.10.2023.
//

import UIKit

public typealias TileView = TileProtocol & UIView

// MARK: - TileCollectionViewControllerProtocol
public protocol TileCollectionViewControllerProtocol: AnyObject {
    
    var presenter: TileCollectionPresenterProtocol? { get set }
    func addTile(tile: any TileProtocol)
    func clearTiles()
    func reloadData()
    func findTile(by id: String) -> (any TileProtocol)?
}

// MARK: - TileCollectionViewController

public class TileCollectionViewController: UICollectionViewController, TileCollectionViewControllerProtocol {
    
    static let reuseIdentifier = "Cell"
    
    private var tiles = [any TileView]()
    private var tilesPerId = [String: any TileView]()
    public var presenter: TileCollectionPresenterProtocol?
    
    public override func viewDidLoad() {
        
        TileCollectionAssembly().assemble(with: self)
        
        super.viewDidLoad()
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: TileCollectionViewController.reuseIdentifier)
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView!.backgroundColor = MainDefaultColors.background.getUIColor()
        
        presenter?.viewDidLoad()
        print("DEBUG: displayed main view")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        showCoinActionWriterViewControllerInCustomizedSheet()
    }
    
    public func clearTiles() {
        tiles = [any TileView]()
        tilesPerId = [String: any TileView]()
    }
    
    public func addTile(tile: any TileProtocol) {
        
        if let tileView = tile as? any TileView {
            tiles.append(tileView)
            tilesPerId[tileView.id] = tileView
        }
    }
    
    public func findTile(by id: String) -> (any TileProtocol)? {
        
        return tilesPerId[id]
    }
    
    public func reloadData() {
        self.collectionView.reloadData()
    }
}

//MARK: - methods CollectionViewController

public extension TileCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection: Int) -> Int {
        tiles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TileCollectionViewController.reuseIdentifier, for: indexPath)
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

//MARK: - show CoinActionWriterViewController (may be move to Router?)

fileprivate extension TileCollectionViewController {
    
    func showCoinActionWriterViewControllerInCustomizedSheet() {
        
        let viewControllerToPresent = CoinActionWriterViewController()
        viewControllerToPresent.initSheetPresentationController();
        
        present(viewControllerToPresent, animated: true, completion: nil)
    }
}
