//
//  ToDoViewModel.swift
//  ToDoList
//
//  Created by Güray Gül on 12.01.2024.
//

import Foundation

class TodoViewModel{

    private let manager = ToDoManager.shared
    
    var tasks: [ToDoList]!
    
    var isEditingModeActive = false
    
    func addTask(name: String, id: Int, isDone: Bool){
        manager.addTask(name: name, id: id, isDone: isDone)
    }
    func deleteTask(_ task: ToDoList){
        manager.deleteTask(task)
    }
    
    func updateTask(_ task: ToDoList){
        manager.updateTask(task)
    }
    
    func updateMode() {
        isEditingModeActive = !isEditingModeActive
    }
    
    func loadTasks() {
        manager.retrieveTodo()
    }
    
    func saveTask(){
        manager.saveTask()
    }
 
}
