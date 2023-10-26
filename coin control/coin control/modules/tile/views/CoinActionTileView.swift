//
//  CoinActionTileView.swift
//  coin control
//
//  Created by Stepan Konashenko on 21.10.2023.
//

import UIKit

//MARK: - CoinActionTileProtocol

public protocol CoinActionTileProtocol: TileProtocol {
    
    func setup(title titleText: String, records recordsTexts: [String])
}

//MARK: - CoinActionTileView

public class CoinActionTileView: UIView, CoinActionTileProtocol {
    
    var titleLabel: UILabel
    var recordLabels: [UILabel]
    
    public init() {
        recordLabels = []
        titleLabel = UILabel()
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(title titleText: String = "unnamed", records recordsTexts: [String]) {
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = TileDefaultColors.background.getUIColor()
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.5
        layer.cornerRadius = 15
        
        displayTitle(text: titleText)
        displayRecords(records: recordsTexts)
        
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
    
    private func displayRecords(records recordsTexts: [String]) {
        
        let recordContainer = createVerticalUIStackView(in: self)
        
        recordsTexts.forEach { recordText in
            
            let recordLabel = UILabel()
            recordLabel.text = recordText
            recordLabel.translatesAutoresizingMaskIntoConstraints = false
            
            recordLabels.append(recordLabel)
            recordContainer.addArrangedSubview(recordLabel)
            
            NSLayoutConstraint.activate([
                recordLabel.leadingAnchor.constraint(equalTo: recordContainer.leadingAnchor),
                recordLabel.trailingAnchor.constraint(equalTo: recordContainer.trailingAnchor)
            ])
        }
    }
}

extension CoinActionTileView: UIStackCreatorProtocol {}

