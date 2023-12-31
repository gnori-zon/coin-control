//
//  CurrencyType.swift
//  coin control
//
//  Created by Stepan Konashenko on 21.10.2023.
//

//MARK: - CurrencyRaw

public typealias CurrencyRaw = (str: String, imagePath: String)

//MARK: - CurrencyType

public enum CurrencyType: Int16 {

    case usd = 1
    case rub = 2
    case eur = 3
    case undefined = -1
    
    var currencyRaw: CurrencyRaw {
        
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
    
    static func of(raw: String) -> CurrencyType? {
        
        switch raw.lowercased() {
            
        case usd.currencyRaw.str:
            return usd
        case eur.currencyRaw.str:
            return eur
        case rub.currencyRaw.str:
            return rub
        default:
            return nil
        }
    }
}

extension CurrencyType: CaseIterable {
    
    static var validCases: [CurrencyType] {
        CurrencyType.allCases.filter { $0.rawValue >= 0 }
    }
}

extension CurrencyType: Codable {}
