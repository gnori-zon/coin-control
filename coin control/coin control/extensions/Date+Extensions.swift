//
//  Date+Extensions.swift
//  coin control
//
//  Created by Stepan Konashenko on 12.11.2023.
//

import Foundation

extension Date {
    
    func shortFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d.M.yyyy"
        
        return dateFormatter.string(from: self)
    }
}
