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
    
    let toDoListManager = ToDoManager()
    let toDoListViewModel = TodoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        collectionView.dragInteractionEnabled = true
        
        toDoListViewModel.loadTasks()
        
        
        // Get items from CoreData
        fetchData()
    }
    
    // MARK: - Add Button
    
//    @IBAction func didAddBarTapped() {
//        let alert = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
//        alert.addTextField()
//        
//        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
//            
//            if let textField = alert.textFields?.first, let newTask = textField.text, !newTask.isEmpty {
//                
//                let newItem = ToDoList(context: self.context)
//                newItem.name = newTask
//                newItem.id = Int64(self.tasks.count) // Adding new items to the bottom of the list
//                newItem.isDone = false
//                
//                self.tasks.append(newItem)
//                
//                self.saveData()
//            }
//        }
//        
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
//            // Do nothing
//        }
//        
//        alert.addAction(ok)
//        alert.addAction(cancel)
//        self.present(alert, animated: true, completion: nil)
//    }
    
    @IBAction func didAddBarTapped(_ sender: Any) {
    
        performSegue(withIdentifier: "showAddToDoViewController", sender: self)

    }
    
    // MARK: - Header View's configuration
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as! HeaderCollectionReusableView
        
        headerView.nickName.text = "Welcome Güray"
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 400)
    }
    
    // MARK: Edit Action
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Which task to edit
        let taskToEdit = self.tasks[indexPath.row]
        
        // Create Alert
        let alert = UIAlertController(title: "Edit Task", message: "Edit Task", preferredStyle: .alert)
        alert.addTextField()
        
        let textField = alert.textFields?.first
        textField?.text = taskToEdit.name
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            // Get the textfield for the alert
            let textField = alert.textFields?.first
            
            // Edit task property of tasks object
            taskToEdit.name = textField?.text
            
            self.toDoListManager.saveTask()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            // Do nothing
        }
        
        alert.addAction(saveButton)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
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
    
}

// MARK: - Configuring collection view cells data

extension ToDoListViewController: UICollectionViewDataSource {
    
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

// MARK: - Updating Order

extension ToDoListViewController: UICollectionViewDelegate {
    
    func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        
        if let item = coordinator.items.first,
           let sourceIndexPath = item.sourceIndexPath {
            
            collectionView.performBatchUpdates({
                self.tasks.remove(at: sourceIndexPath.item)
                self.tasks.insert(item.dragItem.localObject as! ToDoList, at: destinationIndexPath.item)
                
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
                updateOrderValues()
            }, completion: nil)
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
    
    // Updating the orders acording to new order
    func updateOrderValues() {
        for (index, task) in tasks.enumerated() {
            task.id = Int64(index)
        }
    }
    
}

// MARK: - Drag&Drop Feature

extension ToDoListViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let task = tasks[indexPath.item]
        let itemProvider = NSItemProvider(object: task.name! as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = task
        return [dragItem]
    }
}

extension ToDoListViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
        
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
