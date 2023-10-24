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
    
    func setup(title titleText: String, timeUpdate timeUpdateText: String, records currencyRateRecordRaw: [CurrencyRateRecordRaw])
}

//MARK: - CurrencyRateTileView

public class CurrencyRateTileView: UIView, CurrencyRateTileProtocol {
    
    private var titleLabel: UILabel
    private var timeUpdateLabel: UILabel
    private var currencyRateRecords: [CurrencyRateRecord]
    
    public init() {
        titleLabel = UILabel()
        timeUpdateLabel = UILabel()
        currencyRateRecords = []
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(
        title titleText: String,
        timeUpdate timeUpdateText: String,
        records currencyRateRecordRaw: [CurrencyRateRecordRaw]
    ) {
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = TileDefaultColors.background.getUIColor()
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.5
        layer.cornerRadius = 15
        
        displayTitle(text: titleText)
        displayTimeUpdate(textDate: timeUpdateText)
        displayCurrencyRateRecords(rawRecords: currencyRateRecordRaw)
        
        print("DEBUG: displayed CurrencyRateTileView")
    }
    
    private func displayTitle(text: String) {
        
        titleLabel.text = text
        titleLabel.textColor = TileDefaultColors.text.getUIColor()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func displayCurrencyRateRecords(rawRecords: [CurrencyRateRecordRaw]) {
        
        let recordContainer = createVerticalUIStackView(in: self)
        
        rawRecords.forEach { raw in
            
            let recordContainer = createHorizontalUIStackView(in: recordContainer)
            
            let image = UIImage(systemName: raw.imagePath)
            
            let iconView = UIImageView(image: image)
            iconView.tintColor = .black
            
            recordContainer.addSubview(iconView)
            
            let recordLabel = UILabel()
            
            recordLabel.text = raw.text
            recordLabel.translatesAutoresizingMaskIntoConstraints = false
            recordContainer.addSubview(recordLabel)
            
            NSLayoutConstraint.activate([
                recordLabel.topAnchor.constraint(equalTo: recordContainer.topAnchor),
                recordLabel.bottomAnchor.constraint(equalTo: recordContainer.bottomAnchor),
                recordLabel.trailingAnchor.constraint(equalTo: recordContainer.trailingAnchor)
            ])
        }
    }
}

extension CurrencyRateTileView: UIStackCreatorProtocol {}
