//
//  CurrencyType.swift
//  coin control
//
//  Created by Stepan Konashenko on 21.10.2023.
//

//MARK: - CurrencyRawTuple

public typealias CurrencyRawTuple = (str: String, imagePath: String)

//MARK: - CurrencyType

public enum CurrencyType {

    case usd, rub, eur
    
    var currencyRaw: CurrencyRawTuple {
        
        switch self {
            
        case .usd:
            return (str: "usd", imagePath: "dollarsign")
        case .eur:
            return (str: "eur", imagePath: "eurosign")
        case .rub:
            return (str: "rub", imagePath: "rublesign")
        }
    }
}
