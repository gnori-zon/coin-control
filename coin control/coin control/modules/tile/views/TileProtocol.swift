//
//  TileProtocol.swift
//  coin control
//
//  Created by Stepan Konashenko on 22.10.2023.
//

public protocol TileProtocol: Hashable {
    var id: String { get }
}

extension TileProtocol {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        
        return lhs.self == rhs.self && lhs.id == rhs.id
    }
}
