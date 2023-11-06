//
//  CurrencyRateEndpoint.swift
//  coin control
//
//  Created by Stepan Konashenko on 07.11.2023.
//

public enum CurrencyRateEndpoint {
    
    case latestExchangeRates(base: CurrencyType, symbols: [CurrencyType])
    
    var basePath: String { "https://api.apilayer.com" }
    var intermediatePath: String {
        
        switch self {
        case .latestExchangeRates:
            return "/exchangerates_data/latest"
        }
    }
    
    
    func createPath() -> String {
        
        switch self {
        case let .latestExchangeRates(base, symbols):
            let baseString = base.currencyRaw.str.uppercased()
            let symbolsString = symbols.map { $0.currencyRaw.str.uppercased() }.joined(separator: ",")
            
            return "\(basePath)\(intermediatePath)?base=\(baseString)&symbols=\(symbolsString)"
        }
    }
}
