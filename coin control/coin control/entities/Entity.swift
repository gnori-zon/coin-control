//
//  Entity.swift
//  coin control
//
//  Created by Степан Конашенко on 25.10.2023.
//

import CoreData

public protocol Entity {
    associatedtype T: NSManagedObject
    
    static func fetchRequest() -> NSFetchRequest<T>
    static func getDescription(in context:  NSManagedObjectContext) -> NSEntityDescription?
    init(entity: NSEntityDescription, insertInto: NSManagedObjectContext?)
    var id: Int64 { get }
}
