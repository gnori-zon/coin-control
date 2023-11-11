//
//  TileSettingsEntity.swift
//  coin control
//
//  Created by Stepan Konashenko on 25.10.2023.
//
//

import Foundation
import CoreData

@objc(CoinActionTileSettingsEntity)
public final class CoinActionTileSettingsEntity: NSManagedObject {}

//MARK: - TileSettingsEntity

extension CoinActionTileSettingsEntity: TileSettingsEntityProtocol {
    
    private static let entityName = "CoinActionTileSettingsEntity"
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoinActionTileSettingsEntity> {
        return NSFetchRequest<CoinActionTileSettingsEntity>(entityName: entityName)
    }
    
    @nonobjc public class func getDescription(in context:  NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName, in: context)
    }

    @NSManaged public var title: String
    @NSManaged public var coinActionTypeCode: Int16
    @NSManaged public var currencyTypeCode: Int16
    @NSManaged public var sortingTypeCode: Int16
    @NSManaged public var sortingDirectionCode: Int16
    @NSManaged public var id: String
    
    public var coinActionType: CoinActionType {
        
        get {
            return CoinActionType(rawValue: coinActionTypeCode) ?? .undefined
        }
        set {
            coinActionTypeCode = Int16(newValue.rawValue)
        }
    }
    
    public var currencyType: CurrencyType {
        
        get {
            return CurrencyType(rawValue: currencyTypeCode) ?? .undefined
        }
        set {
            currencyTypeCode = Int16(newValue.rawValue)
        }
    }
    
    public var sortingType: SortingType {
        
        get {
            return SortingType(rawValue: sortingTypeCode) ?? .undefined
        }
        set {
            sortingTypeCode = Int16(newValue.rawValue)
        }
    }
    
    public var sortingDirection: SortingDirection {
        
        get {
            return SortingDirection(rawValue: sortingDirectionCode) ?? .undefined
        }
        set {
            sortingDirectionCode = Int16(newValue.rawValue)
        }
    }
}

extension CoinActionTileSettingsEntity : Identifiable {}
