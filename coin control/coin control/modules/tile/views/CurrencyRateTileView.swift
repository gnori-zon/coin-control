//
//  CurrencyRateTileView.swift
//  coin control
//
//  Created by Stepan Konashenko on 23.10.2023.
//

import UIKit

public typealias CurrencyRateRaw = (imagePath: String, text: String)

public protocol CurrencyRateTileProtocol: TileProtocol {
    
    func setup(title titleText: String)
}

//MARK: - CurrencyRateTileView

public final class CurrencyRateTileView: UIView {
    
    static let cellHeight: CGFloat = 30
    static let cellTextSize: CGFloat = 18
    static let reusableId = "CurrencyRateTileCell"
    
    public let id: String
    public var timeUpdatingText: String
    public var currencyRateRaws: [CurrencyRateRaw]
    
    private var titleLabel: UILabel
    private var timeUpdatingLabel: UILabel
    private var currencyRatesTableView: UITableView
    
    public init(_ id: String, records currencyRateRaws: [CurrencyRateRaw], timeUpdating timeUpdatingText: String) {
        
        self.id = id
        self.timeUpdatingText = timeUpdatingText
        self.currencyRateRaws = currencyRateRaws
        titleLabel = UILabel()
        timeUpdatingLabel = UILabel()
        currencyRatesTableView = UITableView()
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - CurrencyRateTileProtocol

extension CurrencyRateTileView: CurrencyRateTileProtocol {
    
    public func setup(title titleText: String) {
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = TileDefaultColors.background.getUIColor()
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.5
        layer.cornerRadius = 15
        
        displayTitle(text: titleText)
        displayTimeUpdate(textDate: timeUpdatingText)
        displayCurrencyRatesTableView()
        
        print("DEBUG: displayed CurrencyRateTileView")
    }
    
    public func reloadContent() {
        
        self.currencyRatesTableView.reloadData()
        self.timeUpdatingLabel.text = timeUpdatingText
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
            titleLabel.widthAnchor.constraint(equalToConstant: 55),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func displayTimeUpdate(textDate: String) {
        
        timeUpdatingLabel.text = textDate
        timeUpdatingLabel.textColor = TileDefaultColors.text.getUIColor()
        timeUpdatingLabel.textAlignment = .center
        timeUpdatingLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timeUpdatingLabel)
        
        NSLayoutConstraint.activate([
            timeUpdatingLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            timeUpdatingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            timeUpdatingLabel.widthAnchor.constraint(equalToConstant: 90),
            timeUpdatingLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func displayCurrencyRatesTableView() {
        
        currencyRatesTableView.dataSource = self
        currencyRatesTableView.delegate = self
        currencyRatesTableView.allowsSelection = false
        currencyRatesTableView.rowHeight = CurrencyRateTileView.cellHeight
        currencyRatesTableView.backgroundColor = .clear
        currencyRatesTableView.isUserInteractionEnabled = false
        currencyRatesTableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(currencyRatesTableView)
        
        NSLayoutConstraint.activate([
            currencyRatesTableView.topAnchor.constraint(equalTo: topAnchor, constant: 35),
            currencyRatesTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            currencyRatesTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            currencyRatesTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
    
}

// MARK: - UITableView delegates

extension CurrencyRateTileView: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencyRateRaws.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = currencyRatesTableView.dequeueReusableCell(withIdentifier: CurrencyRateTileView.reusableId)
        
        if cell == nil {
         
            cell = UITableViewCell(style: .default, reuseIdentifier: CurrencyRateTileView.reusableId)
            cell?.backgroundColor = .clear
        }
       
        cell?.replaceContent(on: currencyRateRaws[indexPath.row])

        return cell!
    }
}

// MARK: - UITableViewCell

extension UITableViewCell: UIStackCreatorProtocol {
    
    fileprivate func replaceContent(on row: CurrencyRateRaw) {
        
        subviews.forEach{ $0.removeFromSuperview() }
        let recordContainer = createHorizontalUIStackView(in: self)

        recordContainer.addImageView(with: row.imagePath)
        recordContainer.addLabel(with: row.text)
    }
}

fileprivate extension UIStackView {
    
    func addImageView(with imagePath: String) {
        
        let image = UIImage(systemName: imagePath)
        let iconView = UIImageView(image: image)
        
        iconView.tintColor = .black
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconView)
        
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    func addLabel(with text: String) {
        
        let label = UILabel()
        
        label.text = text
        label.font = UIFont.systemFont(ofSize: CurrencyRateTileView.cellTextSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
