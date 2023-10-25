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
    
    func create<T: ManagedEntity>(type: T.Type, filler: (T) -> Void)
    
    func fetch<T: ManagedEntity>(type: T.Type) -> [T]
    func fetch<T: ManagedEntity>(type: T.Type, by id: Int64) -> T?
    
    func update<T: ManagedEntity>(type: T.Type, by id: Int64, filler: (T) -> Void)
    
    func delete<T: ManagedEntity>(type: T.Type, by id: Int64)
    func delete<T: ManagedEntity>(type: T.Type)
}

//MARK: - StorageService

public final class StorageService: NSObject, StorageServiceProtocol {

    private static let instance = StorageService()
    public static var shared = {
        instance
    }
    
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    // TODO: add error optional
    public func create<T: ManagedEntity>(type: T.Type, filler: (T) -> Void) {
        
        guard let entityDescription = type.getDescription(in: context) else {
            return
        }
        
        let entity = type.init(entity: entityDescription, insertInto: context)
        filler(entity)
        
        appDelegate.saveContext()
    }
    
    public func fetch<T: ManagedEntity>(type: T.Type) -> [T] {
        
        let fetchRequest = type.fetchRequest()
        
        do {
            return (try? context.fetch(fetchRequest) as? [T]) ?? []
        }
    }
    
    public func fetch<T: ManagedEntity>(type: T.Type, by id: Int64) -> T? {
        
        let fetchRequest = type.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            
            let entities = (try? context.fetch(fetchRequest)) as? [T]
            return entities?.first(where: { $0.id == id })
        }
    }
    
    public func update<T: ManagedEntity>(type: T.Type, by id: Int64, filler: (T) -> Void) {
        
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
    
    public func delete<T: ManagedEntity>(type: T.Type, by id: Int64) {
        
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
