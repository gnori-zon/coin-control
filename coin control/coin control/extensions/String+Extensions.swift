//
//  String+Extensions.swift
//  coin control
//
//  Created by Stepan Konashenko on 12.11.2023.
//

import Foundation

extension String {
    
    func match(_ pattern: String) -> Bool {
        
        do {
            return try self.matches(of: Regex(pattern)).count > 0
        } catch {
            return false
        }
    }
}
