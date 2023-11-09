//
//  EntityFields.swift
//  coin control
//
//  Created by Stepan Konashenko on 06.11.2023.
//

public typealias SortingEntity = (type: SortingType, direction: SortingDirection)

public enum EntityFields: String {
    case coinActionTypeCode, actionTypeCode, id, selectedCurrencyCodes
}
