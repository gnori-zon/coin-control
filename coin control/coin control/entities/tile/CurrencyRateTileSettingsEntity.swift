//
//  CurrencyRateTileSettingsEntity.swift
//  coin control
//
//  Created by Stepan Konashenko on 01.11.2023.
//

import Foundation
import CoreData

@objc(CurrencyRateTileSettingsEntity)
public final class CurrencyRateTileSettingsEntity: NSManagedObject {}

extension CurrencyRateTileSettingsEntity: TileSettingsEntityProtocol {
   
    private static let entityName = "CurrencyRateTileSettingsEntity"
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyRateTileSettingsEntity> {
        return NSFetchRequest<CurrencyRateTileSettingsEntity>(entityName: entityName)
    }
    
    @nonobjc public static func getDescription(in context: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName, in: context)
    }
    
    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var targetCurrencyTypeCode: Int16
    @NSManaged public var selectedCurrencyCodes: String
    
    public var targetCurrencyType: CurrencyType {
        
        get {
            return CurrencyType(rawValue: targetCurrencyTypeCode) ?? .undefined
        }
        set {
            targetCurrencyTypeCode = Int16(newValue.rawValue)
        }
    }
    
    public var selectedCurrencies: [CurrencyType] {
        
        get {
            return selectedCurrencyCodes.split(separator: ",")
                .map{ (Int16($0) ?? CurrencyType.undefined.rawValue) }
                .map{ CurrencyType(rawValue: $0) ?? .undefined }
        }
        set {
            selectedCurrencyCodes = newValue.map{ "\($0.rawValue)" }
                .joined(separator: ",")
        }
    }
}

extension CurrencyRateTileSettingsEntity: Identifiable {}
