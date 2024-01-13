//
//  ToDoViewModel.swift
//  ToDoList
//
//  Created by Güray Gül on 12.01.2024.
//

import Foundation

class TodoViewModel{

    private let manager = ToDoManager.shared
    
    func addTask(name: String, id: Int, isDone: Bool){
        manager.addTask(name: name, id: id, isDone: isDone)
    }
    func deleteTask(_ task: ToDoList){
        manager.deleteTask(task)
    }
    
    func loadTasks() {
        manager.retrieveTodo()
    }
    
    func saveTask(){
        manager.saveTask()
    }
 
}
