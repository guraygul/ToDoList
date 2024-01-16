//
//  ToDo.swift
//  ToDoList
//
//  Created by Güray Gül on 12.01.2024.
//

import UIKit
import CoreData

class ToDoManager {
    static let shared = ToDoManager()
    var tasks: [ToDoList] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addTask(name: String, id: Int, isDone: Bool) {
        let newTask = ToDoList(context: self.context)
        newTask.name = name
        newTask.id = Int64(self.tasks.count)  //Int64(self.tasks.count)
        newTask.isDone = isDone
        
        self.tasks.append(newTask)
        
        self.saveTask()
    }
    
    func deleteTask(_ task: ToDoList) {
        self.context.delete(task)
        saveTask()
    }
    
    func updateTask(_ task: ToDoList) {
        saveTask()
    }
    
    func retrieveTodo(){
        do {
            self.tasks = try context.fetch(ToDoList.fetchRequest())
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func saveTask() {
        do {
            try self.context.save()
            print("Saved successfully!")
        } catch {
            print("An error occured while saving")
        }
        
    }

}
