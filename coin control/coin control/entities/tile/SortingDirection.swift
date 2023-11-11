//
//  SortingDirection.swift
//  coin control
//
//  Created by Stepan Konashenko on 01.11.2023.
//

public enum SortingDirection: Int16 {
    
    case asc = 1
    case desc = 2
    case undefined = -1
    
    var isAscending: Bool {
        
        switch self {
        case .asc:
            return true
        case .desc:
            return false
        case .undefined:
            print("DEBUG: undefined sorting direction")
            return false
        }
    }
}
