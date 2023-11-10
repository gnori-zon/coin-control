//
//  CompoundFilterEntity.swift
//  coin control
//
//  Created by Stepan Konashenko on 09.11.2023.
//

public struct CompoundFilterEntity {
    
    let filters: [FilterEntity]
    let joiner: FilterJoinType
    
    static var empty: CompoundFilterEntity { CompoundFilterEntity(filters: [], joiner: .and) }
}
