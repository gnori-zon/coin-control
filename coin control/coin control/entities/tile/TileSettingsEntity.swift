//
//  TileSettingsEntity.swift
//  coin control
//
//  Created by Stepan Konashenko on 25.10.2023.
//
//

import Foundation
import CoreData

@objc(TileSettingsEntity)
public final class TileSettingsEntity: NSManagedObject {

}

//MARK: - TileSettingsEntity

extension TileSettingsEntity: Entity {
    
    private static let entityName = "TileSettingsEntity"
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TileSettingsEntity> {
        return NSFetchRequest<TileSettingsEntity>(entityName: entityName)
    }
    
    @nonobjc public class func getDescription(in context:  NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName, in: context)
    }

    @NSManaged public var title: String
    @NSManaged public var tileTypeCode: Int16
    @NSManaged public var currencyTypeCode: Int16
    @NSManaged public var id: String
    
    public var tileType: TileType {
        
        get {
            return TileType(rawValue: Int16(self.tileTypeCode)) ?? .undefined
        }
        set {
            self.tileTypeCode = Int16(newValue.rawValue)
        }
    }
    
    public var currencyType: CurrencyType {
        
        get {
            return CurrencyType(rawValue: currencyTypeCode) ?? .undefined
        }
        set {
            self.currencyTypeCode = Int16(newValue.rawValue)
        }
    }

}

extension TileSettingsEntity : Identifiable {

}
