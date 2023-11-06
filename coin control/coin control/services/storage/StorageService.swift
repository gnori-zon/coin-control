//
//  StorageService.swift
//  coin control
//
//  Created by Stepan Konashenko on 25.10.2023.
//

import UIKit
import CoreData

public typealias ManagedEntity = Entity & NSManagedObject

//MARK: - StorageServiceProtocol

public protocol StorageServiceProtocol {
    associatedtype S
    
    static var shared: S { get }
    
    func create<T: ManagedEntity>(type: T.Type, filler: (T) -> Void) -> T?
    
    func fetch<T: ManagedEntity>(type: T.Type) -> [T]
    func fetch<T: ManagedEntity>(type: T.Type, by id: String) -> T?
    func fetch<T: ManagedEntity>(type: T.Type, where filters: [FilterEntities]) -> [T]
    
    func update<T: ManagedEntity>(type: T.Type, by id: String, filler: (T) -> Void)
    
    func delete<T: ManagedEntity>(type: T.Type, by id: String)
    func delete<T: ManagedEntity>(type: T.Type)
}

//MARK: - StorageService

public final class StorageService: NSObject, StorageServiceProtocol {

    private static let instance = StorageService()
    public static var shared = {
        instance
    }
    
    private override init() {}
    
    private var appDelegate: AppDelegate = {
        UIApplication.shared.delegate as! AppDelegate
    }()
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    // TODO: add error optional
    public func create<T: ManagedEntity>(type: T.Type, filler: (T) -> Void) -> T? {
        
        guard let entityDescription = type.getDescription(in: context) else {
            return nil
        }
        
        var entity = type.init(entity: entityDescription, insertInto: context)
        filler(entity)
        entity.id = entity.objectID.uriRepresentation().absoluteString
        
        appDelegate.saveContext()
        
        return entity
    }
    
    public func fetch<T: ManagedEntity>(type: T.Type) -> [T] {
        
        let fetchRequest = type.fetchRequest()
        
        do {
            return (try? context.fetch(fetchRequest) as? [T]) ?? []
        }
    }
    
    public func fetch<T: ManagedEntity>(type: T.Type, by id: String) -> T? {
        
        return fetch(type: type, where: [(field: .id, .equals, id)]).first(where: { $0.id == id })
    }
    
    public func fetch<T: ManagedEntity>(type: T.Type, where filters: [FilterEntities]) -> [T] {
        
        let fetchRequest = type.fetchRequest()
        
        filters.forEach { filter in
            
            tryAddPredicateOf(to: fetchRequest, filter: filter)
        }

        do {
            
            let entities = (try? context.fetch(fetchRequest)) as? [T]
            return entities ?? []
        }
    }
    
    public func update<T: ManagedEntity>(type: T.Type, by id: String, filler: (T) -> Void) {
        
        let fetchRequest = type.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            
            let entities = (try? context.fetch(fetchRequest)) as? [T]
            let entity = entities?.first(where: { $0.id == id })
            
            if let entity {
                filler(entity)
            }
            
            appDelegate.saveContext()
        }
    }
    
    public func delete<T: ManagedEntity>(type: T.Type, by id: String) {
        
        let fetchRequest = type.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            
            let entities = (try? context.fetch(fetchRequest)) as? [T]
            let entity = entities?.first(where: { $0.id == id })
            
            if let entity {
                context.delete(entity)
            }
            
            appDelegate.saveContext()
        }
    }
    
    public func delete<T: ManagedEntity>(type: T.Type) {
        
        let fetchRequest = type.fetchRequest()
        
        do {
            
            let entities = (try? context.fetch(fetchRequest)) as? [T]
            entities?.forEach { context.delete($0) }
            
            appDelegate.saveContext()
        }
    }
    
    private func tryAddPredicateOf<T>(to fetchRequest: NSFetchRequest<T>, filter: FilterEntities) {
        
        let objectFormatPattern = "%K %@ %@"
        let numberFormatPattern = "%@ %@ %i"
        let decimalFormatPattern = "%@ %@ %x"
        
        let field = filter.field.rawValue
        let sign = filter.sign.rawValue
        let value = filter.value
        
        if let strValue = value as? String {
            fetchRequest.predicate = NSPredicate(format: objectFormatPattern, field, sign, strValue)
            
        } else if let int16Value = value as? Int16 {
            fetchRequest.predicate = NSPredicate(format: String(format: numberFormatPattern, field, sign, int16Value))
            
        }else if let dateValue = value as? NSDate {
            fetchRequest.predicate = NSPredicate(format: objectFormatPattern, field, sign, dateValue)
            
        } else if let decimalValue = value as? NSDecimalNumber {
            fetchRequest.predicate = NSPredicate(format: String(format: decimalFormatPattern, field, sign, decimalValue))
        }
    }
}
