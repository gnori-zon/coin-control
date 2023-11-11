//
//  Array+Extensions.swift
//  coin control
//
//  Created by Stepan Konashenko on 12.11.2023.
//

import Foundation

extension Array {
    
    func peek(_ action: (Element) -> Void) -> [Element] {
        
        return self.map { element in
            
            action(element)
            return element
        }
    }
}
