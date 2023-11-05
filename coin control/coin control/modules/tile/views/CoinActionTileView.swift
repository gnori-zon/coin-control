//
//  CoinActionTileView.swift
//  coin control
//
//  Created by Stepan Konashenko on 21.10.2023.
//

import UIKit

//MARK: - CoinActionTileProtocol

public protocol CoinActionTileProtocol: TileProtocol {
    
    func setup(title titleText: String)
}

//MARK: - CoinActionTileView

public class CoinActionTileView: UIView, CoinActionTileProtocol {
    
    static let cellHeight: CGFloat = 22
    static let cellTextSize: CGFloat = 14
    static let reusableId = "CoinActionTileCell"
    
    private var titleLabel: UILabel
    private let recordsTableView: UITableView
    var records: [String]
    public let id: String
    
    public init(_ id: String, records: [String]) {
        
        self.id = id
        self.records = records
        recordsTableView = UITableView()
        titleLabel = UILabel()
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(title titleText: String = "unnamed") {
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = TileDefaultColors.background.getUIColor()
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.5
        layer.cornerRadius = 15
        
        displayTitle(text: titleText)
        displayRecords()
        
        print("DEBUG: displayed CoinActionTileView")
    }
    
    private func displayTitle(text: String) {
        
        titleLabel.text = text
        titleLabel.textColor = TileDefaultColors.text.getUIColor()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.adjustsFontSizeToFitWidth = true
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func displayRecords() {
        
        recordsTableView.delegate = self
        recordsTableView.dataSource = self
        recordsTableView.isScrollEnabled = false
        recordsTableView.isUserInteractionEnabled = false
        recordsTableView.backgroundColor = .clear
        recordsTableView.rowHeight = CoinActionTileView.cellHeight
        recordsTableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(recordsTableView)
        
        NSLayoutConstraint.activate([
            recordsTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            recordsTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            recordsTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            recordsTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}

extension CoinActionTileView: UIStackCreatorProtocol {}

// MARK: - UITableView delegates

extension CoinActionTileView: UITableViewDelegate, UITableViewDataSource {
    
    public func reloadContent() {
        self.recordsTableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.records.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: CoinActionTileView.reusableId)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: CoinActionTileView.reusableId)
        }
        cell?.textLabel?.textAlignment = .left
        cell?.textLabel?.font = UIFont.systemFont(ofSize: CoinActionTileView.cellTextSize)
        cell?.textLabel?.textColor = .black
        cell?.backgroundColor = .clear
        cell?.textLabel?.text = self.records[indexPath.row]
        
        return cell!
    }
}
