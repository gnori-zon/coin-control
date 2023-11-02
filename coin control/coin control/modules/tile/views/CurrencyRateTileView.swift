//
//  CurrencyRateTileView.swift
//  coin control
//
//  Created by Stepan Konashenko on 23.10.2023.
//

import UIKit

//MARK: - CurrencyRateRecord

public typealias CurrencyRateRecord = (icon: UIImage, label: UILabel)
public typealias CurrencyRateRecordRaw = (imagePath: String, text: String)

//MARK: - CurrencyRateTileProtocol

public protocol CurrencyRateTileProtocol: TileProtocol {
    
    func setup(title titleText: String, timeUpdate timeUpdateText: String)
}

//MARK: - CurrencyRateTileView

public class CurrencyRateTileView: UIView, CurrencyRateTileProtocol {
    
    static let cellHeight: CGFloat = 30
    static let cellTextSize: CGFloat = 18
    static let reusableId = "CurrencyRateTileCell"
    
    private var titleLabel: UILabel
    private var timeUpdateLabel: UILabel
    private var currencyRateRecordsTableView: UITableView
    var currencyRateRecordRaws: [CurrencyRateRecordRaw]
    let id: String
    
    public init(_ id: String, records currencyRateRecordRaws: [CurrencyRateRecordRaw]) {
        
        self.id = id
        self.currencyRateRecordRaws = currencyRateRecordRaws
        titleLabel = UILabel()
        timeUpdateLabel = UILabel()
        currencyRateRecordsTableView = UITableView()
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(
        title titleText: String,
        timeUpdate timeUpdateText: String
    ) {
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = TileDefaultColors.background.getUIColor()
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.5
        layer.cornerRadius = 15
        
        displayTitle(text: titleText)
        displayTimeUpdate(textDate: timeUpdateText)
        displayCurrencyRateRecords()
        
        print("DEBUG: displayed CurrencyRateTileView")
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
            titleLabel.widthAnchor.constraint(equalToConstant: 75),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func displayTimeUpdate(textDate: String) {
        
        timeUpdateLabel.text = textDate
        timeUpdateLabel.textColor = TileDefaultColors.text.getUIColor()
        timeUpdateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timeUpdateLabel)
        
        NSLayoutConstraint.activate([
            timeUpdateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            timeUpdateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            timeUpdateLabel.widthAnchor.constraint(equalToConstant: 75),
            timeUpdateLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func displayCurrencyRateRecords() {
        
        currencyRateRecordsTableView.dataSource = self
        currencyRateRecordsTableView.delegate = self
        currencyRateRecordsTableView.rowHeight = CurrencyRateTileView.cellHeight
        currencyRateRecordsTableView.backgroundColor = .clear
        currencyRateRecordsTableView.isUserInteractionEnabled = false
        currencyRateRecordsTableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(currencyRateRecordsTableView)
        
        NSLayoutConstraint.activate([
            currencyRateRecordsTableView.topAnchor.constraint(equalTo: topAnchor, constant: 35),
            currencyRateRecordsTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            currencyRateRecordsTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            currencyRateRecordsTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
    
}

// MARK: - UITableView delegates

extension CurrencyRateTileView: UITableViewDelegate, UITableViewDataSource {
    
    public func reloadData() {
        self.currencyRateRecordsTableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencyRateRecordRaws.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = currencyRateRecordsTableView.dequeueReusableCell(withIdentifier: CurrencyRateTileView.reusableId)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: CurrencyRateTileView.reusableId)
        }
        cell?.backgroundColor = .clear
        
        cell?.fill(from: currencyRateRecordRaws, by: indexPath)

        return cell!
    }
}

extension UITableViewCell: UIStackCreatorProtocol {
    
    fileprivate func fill(from currencyRateRecordRaws: [CurrencyRateRecordRaw], by indexPath: IndexPath) {
        
        let recordContainer = createHorizontalUIStackView(in: self)
        let row = currencyRateRecordRaws[indexPath.row]

        let image = UIImage(systemName: row.imagePath)
        let iconView = UIImageView(image: image)
        iconView.tintColor = .black
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        recordContainer.addSubview(iconView)
        
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: recordContainer.centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: recordContainer.leadingAnchor)
        ])
        
        let recordLabel = UILabel()
        
        recordLabel.text = row.text
        recordLabel.font = UIFont.systemFont(ofSize: CurrencyRateTileView.cellTextSize)
        recordLabel.translatesAutoresizingMaskIntoConstraints = false
        recordContainer.addSubview(recordLabel)
        
        NSLayoutConstraint.activate([
            recordLabel.topAnchor.constraint(equalTo: recordContainer.topAnchor),
            recordLabel.bottomAnchor.constraint(equalTo: recordContainer.bottomAnchor),
            recordLabel.trailingAnchor.constraint(equalTo: recordContainer.trailingAnchor)
        ])
    }
}
