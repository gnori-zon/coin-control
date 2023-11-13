//
//  MockHttpRequestSender.swift
//  coin controlTests
//
//  Created by Stepan Konashenko on 13.11.2023.
//

import Foundation
import coin_control

final class MockHttpRequestSender: HttpRequestSenderProtocol {
    
    private var result: Result<Any, Error>? = nil
    
    func sendRequest<T>(
        _ request: URLRequest,
        completionHandler: @escaping (Result<T, Error>) -> Void
    ) where T : Decodable, T : Encodable {
        
        guard let result else {
            return
        }
        
        switch result {
        case .success(let value):
            
            guard let success = value as? T else {
                return
            }
            
            completionHandler(Result.success(success))
        
        case .failure(let error):
            completionHandler(Result.failure(error))
        }
    }
    
    func shouldSuccess<T>(_ success: T) {
        result = Result.success(success)
    }
    
    func shouldError(_ error: Error) {
        result = Result.failure(error)
    }
}
