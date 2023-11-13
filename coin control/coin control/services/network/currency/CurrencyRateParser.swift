//
//  CurrencyRateParser.swift
//  coin control
//
//  Created by Stepan Konashenko on 07.11.2023.
//

import Foundation

public protocol CurrencyRateParserProtocol {
    
    func tryParse(target: CurrencyType, ratioCurrencyTypes: [CurrencyType], completionHandler: @escaping (CurrencyRateProtocol) -> Void) async
    func generateUrlRequest(target: CurrencyType, ratioCurrencyTypes: [CurrencyType]) -> URLRequest
}

public struct CurrencyRateParser: CurrencyRateParserProtocol {
    
    private let apiKeyHeaderName = "apikey"
    private let apiKeyHeaderValue = "#####"
    
    let converter: CurrencyRateResponseConverterProtocol
    let requestSender: HttpRequestSenderProtocol
    
    public func tryParse(target: CurrencyType, ratioCurrencyTypes: [CurrencyType], completionHandler: @escaping (CurrencyRateProtocol) -> Void) async {
        
        let request = generateUrlRequest(target: target, ratioCurrencyTypes: ratioCurrencyTypes)
        
        requestSender.sendRequest(request) { (result: Result<CurrencyRateResponse, any Error>) in
            
            switch result {
                
            case let .success(currencyRateResponse):
                
                guard let currencyRate = converter.convert(from: currencyRateResponse) else {
                    // TODO: publish unknown error failure notification
                    print("DEBUG : unknown error")
                    return
                }
                print("DEBUG: success -> \(currencyRate.description)")
                
                completionHandler(currencyRate)
               
            case let .failure(error):
                // TODO: process error and publish failure notification
                print("DEBUG : failure -> \(error.description)")
            }
        }
    }
    
    public func generateUrlRequest(target: CurrencyType, ratioCurrencyTypes: [CurrencyType]) -> URLRequest {
        
        let path = CurrencyRateEndpoint.latestExchangeRates(base: target, symbols: ratioCurrencyTypes).createPath()
        
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = HttpMethod.get.rawValue
        request.allHTTPHeaderFields = [apiKeyHeaderName: apiKeyHeaderValue]

        return request
    }
}

// MARK: - describing

fileprivate extension CurrencyRateProtocol {
    
    var description: String {
        String(describing: self)
    }
}

fileprivate extension Error {
    
    var description: String {
        String(describing: self)
    }
}
