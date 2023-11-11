//
//  FilterSign.swift
//  coin control
//
//  Created by Stepan Konashenko on 06.11.2023.
//

public enum FilterSign: String {
    
    case equals = "=="
    case notEquals = "!="
    case larger = ">"
    case lower = "<"
    case largerOrEqual = ">="
    case lowerOrEqual = "<="
    case like = "like"
}
