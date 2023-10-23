//
//  CurrencyType.swift
//  coin control
//
//  Created by Stepan Konashenko on 21.10.2023.
//

//MARK: - CurrencyRawTuple

public typealias CurrencyRawTuple = (str: String, sign: Character)

//MARK: - CurrencyType

public enum CurrencyType {

    case usd, rub, eur
    
    var currencyRaw: CurrencyRawTuple {
        
        switch self {
            
        case .usd:
            return (str: "usd", sign: "$")
        case .eur:
            return (str: "eur", sign: "€")
        case .rub:
            return (str: "rub", sign: "₽")
        }
    }
}
