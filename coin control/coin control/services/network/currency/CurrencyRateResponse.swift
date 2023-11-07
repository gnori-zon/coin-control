//
//  CurrencyRateResponse.swift
//  coin control
//
//  Created by Stepan Konashenko on 07.11.2023.
//

// MARK: - CurrencyRateResponse

public struct CurrencyRateResponse: Codable {
    
    let base: String
    let date: String
    let rates: Rates
    let success: Bool
    let timestamp: Int
    
}

// MARK: - Rates

public struct Rates: Codable {
    let eur, rub, usd: Double?

    enum CodingKeys: String, CodingKey {
        case eur = "EUR"
        case rub = "RUB"
        case usd = "USD"
    }
}
