//
//  HttpError.swift
//  coin control
//
//  Created by Stepan Konashenko on 07.11.2023.
//

public enum HttpError: Error {
    
    case http(statusCode: Int)
    case badResponseData
    case undefined
}
