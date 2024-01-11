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
    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        // Get items from CoreData
        fetchData()
    }



    // MARK: - Add Button
    
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
    
    // MARK: - Favorite Function
    
    
    
    
    // MARK: - Header View's configuration
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as! HeaderCollectionReusableView
            
            headerView.nickName.text = "Welcome Güray"
            return headerView
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 400)
    }

    // MARK: - Fetching Data
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
    
    // MARK: - Saving Data
    
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

// MARK: - Configuring collection view cells data

extension ToDoListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let task = self.tasks[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "toDoCell", for: indexPath) as! ToDoCollectionViewCell
        cell.nameLabel.text = task.name
        cell.task = task
        
        cell.updateCheckmark()
        
        return cell
    }
    
}

// MARK: - Configuring collection view cells size

extension ToDoListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return sectionInsets
        }
    
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return sectionInsets.left
        }
}
