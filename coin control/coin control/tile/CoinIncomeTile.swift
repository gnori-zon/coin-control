//
//  CoinIncomeTile.swift
//  coin control
//
//  Created by Stepan Konashenko on 21.10.2023.
//

import UIKit

public class CoinIncomeTile: UIView, CoinActionTypeTileProtocol {
    
    var title: UILabel?
    var records: [UILabel]?
    
    public override init(frame: CGRect = CGRect()) {
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(titleText: String = "unnamed") {
        
        backgroundColor = TileDefaultColors.background.getUIColor()
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.5
        layer.cornerRadius = 15
        
        records = []
        title = UILabel(frame: CGRect(x: 15, y: 5, width: frame.width, height: frame.height / 6))
        
        displayTitle(text: titleText)
        displayRecords()
        
        print("DEBUG: displayed CoinIncomeTile view")
    }
    
    private func displayTitle(text: String) {
        
        guard let title else {
            print("WARN: title from CoinIncomeTile is nil")
            return
        }
        
        title.text = text
        title.textColor = TileDefaultColors.text.getUIColor()
        addSubview(title)
    }
    
    private func displayRecords() {
        
        guard var records else {
            print("WARN: records from CoinIncomeTile is nil")
            return
        }
        
        // todo: getting records from memory
        for idx in 2...5 {
            let record = UILabel(frame: CGRect(x: 15, y: (5.0 + (CGFloat(idx) * 20)), width: frame.width, height: frame.height / 6))
            record.text = "\(idx - 1) - \(idx * 2) rub"
            records.append(record)
        }
        //
        records.forEach { self.addSubview($0) }
    }
}
