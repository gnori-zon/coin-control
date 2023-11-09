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
    func fetch<T: ManagedEntity>(type: T.Type, where filtering: CompoundFilterEntity, orderBy sorting: [SortingEntity]) -> [T]
    func fetch<T: ManagedEntity>(type: T.Type, where filtering: CompoundFilterEntity) -> [T]
    func fetch<T: ManagedEntity>(type: T.Type, orderBy sorting: [SortingEntity]) -> [T]
    
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
        
        return fetch(type: type, where: CompoundFilterEntity(filters: [FilterEntity(field: .id, sign: .equals, value: id)], joiner: .and)).first(where: { $0.id == id })
    }
    
    public func fetch<T: ManagedEntity>(type: T.Type, where filtering: CompoundFilterEntity) -> [T] {
        return fetch(type: type, where: filtering, orderBy: [])
    }
    
    public func fetch<T: ManagedEntity>(type: T.Type, orderBy sorting: [SortingEntity]) -> [T] {
        return fetch(type: type, where: CompoundFilterEntity.empty, orderBy: sorting)
    }
    
    public func fetch<T: ManagedEntity>(type: T.Type, where filtering: CompoundFilterEntity, orderBy sorting: [SortingEntity]) -> [T] {
        
        let fetchRequest = type.fetchRequest()
        
        fetchRequest.predicate = filtering.toPredicate()
        fetchRequest.sortDescriptors = sorting.toSortDescriptors()

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
}

fileprivate extension Array where Element == SortingEntity {

    func toSortDescriptors() -> [NSSortDescriptor] {
        
        return self.map { (type: SortingType, direction: SortingDirection) in
            
            NSSortDescriptor(key: type.field, ascending: direction.isAscending)
        }
    }
}

fileprivate extension CompoundFilterEntity{
    
    func toPredicate() -> NSCompoundPredicate {
        
        let predicates = self.filters.compactMap { $0.toPredicate() }
        
        switch joiner {
        case .and:
            return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        case .or:
            return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        }
    }
}

fileprivate extension FilterEntity {
    
    func toPredicate() -> NSPredicate? {
        
        let objectFormatPattern = "%@ %@ %@"
        let numberFormatPattern = "%@ %@ %i"
        let decimalFormatPattern = "%@ %@ %x"
        
        let field = field.rawValue
        let sign = sign.rawValue
        let value = value
        
        if let strValue = value as? String {
            return NSPredicate(format: String(format: objectFormatPattern, field, sign, strValue))
            
        } else if let int16Value = value as? Int16 {
            return NSPredicate(format: String(format: numberFormatPattern, field, sign, int16Value))
            
        }else if let dateValue = value as? NSDate {
            return NSPredicate(format: String(format: objectFormatPattern, field, sign, dateValue))
            
        } else if let decimalValue = value as? NSDecimalNumber {
            return NSPredicate(format: String(format: decimalFormatPattern, field, sign, decimalValue))
        }
        
        return nil
    }
}
