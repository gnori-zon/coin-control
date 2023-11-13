//
//  DateWithRepresentationProtocol.swift
//  coin controlTests
//
//  Created by Stepan Konashenko on 14.11.2023.
//

import Foundation

protocol DateWithRepresentationProtocol {
    
    func dateWithRepresentationOf(
        year: Int,
        month: Int,
        day: Int
    ) -> (date: Date, representation: String)
}

extension DateWithRepresentationProtocol {
    
    func dateWithRepresentationOf(
        year: Int,
        month: Int,
        day: Int
    ) -> (date: Date, representation: String) {
        
        let dayString = day.representation(prefix: "0", if: { $0 < 10})
        let monthString = month.representation(prefix: "0", if: { $0 < 10})
        
        let dateStringRepresentation = "\(year)-\(monthString)-\(dayString)"
        
        let date = DateComponents(calendar: Calendar.current, year: year, month: month, day: day).date!
        
        return (date, dateStringRepresentation)
    }
}

fileprivate extension Int {
    
    func representation(prefix: String, if condition: (Int) -> Bool) -> String {
        
        return condition(self)
        ? "\(prefix)\(self)"
        : "\(self)"
    }
}
