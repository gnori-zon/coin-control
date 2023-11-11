//
//  FilterEntitiesFields.swift
//  coin control
//
//  Created by Stepan Konashenko on 06.11.2023.
//

public typealias FilterEntities = (field: String, sign: FilterSign, value: Any)

public enum FilterEntitiesFields: String {
    case coinActionTypeCode, actionTypeCode
}
