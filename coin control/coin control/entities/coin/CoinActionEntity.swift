//
//  CoinActionEntity.swift
//  coin control
//
//  Created by Stepan Konashenko on 25.10.2023.
//
//

import Foundation
import CoreData

@objc(CoinActionEntity)
public final class CoinActionEntity: NSManagedObject {

}

//MARK: - CoinActionEntity

extension CoinActionEntity: Entity {
    
    private static let entityName = "CoinActionEntity"
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoinActionEntity> {
        return NSFetchRequest<CoinActionEntity>(entityName: entityName)
    }
    
    @nonobjc public class func getDescription(in context:  NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName, in: context)
    }

    @NSManaged public var value: NSDecimalNumber
    @NSManaged public var date: Date
    @NSManaged public var actionTypeCode: Int16
    @NSManaged public var currencyTypeCode: Int16
    @NSManaged public var id: String
    
    public var actionType: CoinActionType {
        
        get {
            return CoinActionType(rawValue: actionTypeCode) ?? .undefined
        }
        set {
            actionTypeCode = Int16(newValue.rawValue)
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

}

extension CoinActionEntity : Identifiable {

}

