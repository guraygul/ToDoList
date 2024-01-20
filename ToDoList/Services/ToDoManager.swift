//
//  ToDo.swift
//  ToDoList
//
//  Created by Güray Gül on 12.01.2024.
//

import UIKit
import CoreData

class ToDoManager {
    
    var tasks: [ToDoList] = []
    
    static let shared = ToDoManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var isEditingModeActive = false
    
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
        self.saveTask()
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
