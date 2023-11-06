//
//  SortingType.swift
//  coin control
//
//  Created by Stepan Konashenko on 01.11.2023.
//

public enum SortingType: Int16 {
    
    case date = 1
    case value = 2

    case undefined = -1
    
    var field: String {
        
        switch self {
        case .date:
            return "date"
        case .value:
            return "value"
        case .undefined:
            print("DEBUG: undefined sorting type")
            return "id"
        }
    }
}
