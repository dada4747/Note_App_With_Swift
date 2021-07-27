//
//  ToDoListItem+CoreDataProperties.swift
//  
//
//  Created by gadgetzone on 25/07/21.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var desc: String?
    @NSManaged public var title: String?

}
