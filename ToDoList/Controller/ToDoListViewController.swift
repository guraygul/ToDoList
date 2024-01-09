//
//  ViewController.swift
//  ToDoList
//
//  Created by Güray Gül on 9.01.2024.
//

import UIKit

class ToDoListViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    private var tasks = [ToDoList]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Get items from CoreData
        fetchData()
    }

    // MARK: Fetching Data
    func fetchData() {
        // Fetch the data from CoreData to display in the tableview
        do {
            let request = ToDoList.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            tasks = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        catch {
            // error handling
        }
    }

    // MARK: Add Button
    @IBAction func didAddBarTapped() {
        let alert = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            
            if let textField = alert.textFields?.first, let newTask = textField.text, !newTask.isEmpty {
                
                let newItem = ToDoList(context: self.context)
                newItem.name = newTask
                newItem.id = Int64(self.tasks.count) // Adding new items to the bottom of the list
                newItem.isDone = false
                
                self.tasks.append(newItem)
                
                self.saveData()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            // Do nothing
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Save Data
    func saveData() {
        do {
            try self.context.save()
        }
        catch {
            // Error handling
        }
        self.fetchData()
    }
    
}

extension ToDoListViewController: UICollectionViewDelegate {
    
}

extension ToDoListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tasks.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let task = self.tasks[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "toDoCell", for: indexPath) as! ToDoCollectionViewCell
        cell.nameLabel.text = task.name
        return cell
    }
    
    
}
