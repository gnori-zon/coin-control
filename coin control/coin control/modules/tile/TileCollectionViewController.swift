//
//  TileCollectionViewController.swift
//  coin control
//
//  Created by Stepan Konashenko on 21.10.2023.
//

import UIKit

public typealias TileView = TileProtocol & UIView

public protocol TileCollectionViewControllerProtocol: AnyObject {
    
    var presenter: TileCollectionPresenterProtocol? { get set }
    func addTile(tile: any TileProtocol)
    func clearTiles()
    func reloadData()
    func findTile(by id: String) -> (any TileProtocol)?
}

// MARK: - TileCollectionViewController

public final class TileCollectionViewController: UICollectionViewController {
    
    static let reuseIdentifier = "TileCell"
    
    private var tiles = [any TileView]()
    private var tilesById = [String: any TileView]()
    public var presenter: TileCollectionPresenterProtocol?
    
    public override func viewDidLoad() {
        
        TileCollectionAssembly().assemble(with: self)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: TileCollectionViewController.reuseIdentifier)
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.backgroundColor = MainDefaultColors.background.getUIColor()
        
        super.viewDidLoad()
        print("DEBUG: displayed main view")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        presenter?.viewDidAppear()
    }
}

//MARK: - TileCollectionViewControllerProtocol

extension TileCollectionViewController: TileCollectionViewControllerProtocol {
    
    public func addTile(tile: any TileProtocol) {
        
        if let tileView = tile as? any TileView {
            tiles.append(tileView)
            tilesById[tileView.id] = tileView
        }
    }
    
    public func findTile(by id: String) -> (any TileProtocol)? {
        
        return tilesById[id]
    }
    
    public func reloadData() {
        self.collectionView.reloadData()
    }
    
    public func clearTiles() {
        tiles = [any TileView]()
        tilesById = [String: any TileView]()
    }
}

//MARK: - CollectionViewController

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
