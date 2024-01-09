//
//  ToDoList+CoreDataProperties.swift
//  ToDoList
//
//  Created by Güray Gül on 9.01.2024.
//
//

import Foundation
import CoreData


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var isDone: Bool

}

extension ToDoList : Identifiable {

}
