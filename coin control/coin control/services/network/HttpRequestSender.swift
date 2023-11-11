//
//  HttpRequestSender.swift
//  coin control
//
//  Created by Stepan Konashenko on 07.11.2023.
//

import Foundation

public protocol HttpRequestSenderProtocol {
    
    func sendRequest<T: Codable>(_ request: URLRequest, completionHandler: @escaping (Result<T, any Error>) -> Void)
}

public struct HttpRequestSender: HttpRequestSenderProtocol {
    
    
    public func sendRequest<T: Codable>(_ request: URLRequest, completionHandler: @escaping (Result<T, any Error>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data,
                  let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                
                completionHandler(identifyFailureResultBy(response, error))
                return
            }
            
            completionHandler(Result.success(decodedData))
        }
        
        task.resume()
    }
    
    private func identifyFailureResultBy<T: Codable>(_ response: URLResponse?, _ error: Error?) -> Result<T, any Error>{
        
        let statusCode = response.map { $0 as? HTTPURLResponse }?.map { $0.statusCode }
        
        if let statusCode, isErrorStatusCode(statusCode) {
            return Result.failure(HttpError.http(statusCode: statusCode))
        }
        
        if let error {
            return Result.failure(error)
        }
        
        return Result.failure(HttpError.badResponseData)
        
    }
    
    private func isErrorStatusCode(_ statusCode: Int) -> Bool {
        statusCode > 399
    }
}
