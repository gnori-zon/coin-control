//
//  CurrencyType.swift
//  coin control
//
//  Created by Stepan Konashenko on 21.10.2023.
//

//MARK: - CurrencyRawTuple

public typealias CurrencyRawTuple = (str: String, imagePath: String)

//MARK: - CurrencyType

public enum CurrencyType: Int16 {

    case usd = 1
    case rub = 2
    case eur = 3
    
    case undefined = -1
    
    var currencyRaw: CurrencyRawTuple {
        
        switch self {
            
        case .usd:
            return (str: "usd", imagePath: "dollarsign")
        case .eur:
            return (str: "eur", imagePath: "eurosign")
        case .rub:
            return (str: "rub", imagePath: "rublesign")
        case .undefined:
            return(str: "?", imagePath: "")
        }
    }
}
