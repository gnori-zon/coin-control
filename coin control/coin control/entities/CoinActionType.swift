//
//  CoinActionType.swift
//  coin control
//
//  Created by Stepan Konashenko on 21.10.2023.
//

public enum CoinActionType: Int16, CaseIterable {
    
    case income = 1
    case outcome = 2
    
    case undefined = -1
    
    var rawStr: String {
        
        switch self {
        case .income:
            return "Прибыль"
        case .outcome:
            return "Траты"
        case .undefined:
            return ""
        }
    }
    
    static var validCases: [CoinActionType] {
        CoinActionType.allCases.filter { $0.rawValue >= 0 }
    }
}
