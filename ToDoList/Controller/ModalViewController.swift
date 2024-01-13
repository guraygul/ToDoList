//
//  ModalViewController.swift
//  ToDoList
//
//  Created by Güray Gül on 12.01.2024.
//

import UIKit

class ModalViewController: UIViewController {
    
    var task = ToDoList()
    var tasks = [ToDoList]()
    @IBOutlet weak var addTasks: UIView!
    
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var inputTask: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let toDoListManager = ToDoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Notifies the view if keyboard is open or close
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

//MARK: - ACTIONS

extension ModalViewController{
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        if inputTask.text == "" {
            
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
//        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
//            task = ToDoList(context: appDelegate.persistentContainer.viewContext)
//            
//            task.name = inputTask.text!
//            task.id = Int64(self.tasks.count)
//            task.isDone = false
//            
//            print("Saving data to context...")
//            appDelegate.saveContext()
//            
//        }
            if let textField = inputTask, let newTask = textField.text, !newTask.isEmpty {

                let newItem = ToDoList(context: self.context)
                newItem.name = newTask
                newItem.id = Int64(self.tasks.count) // Adding new items to the bottom of the list
                newItem.isDone = false

                self.tasks.append(newItem)

                toDoListManager.saveTask()
            }
        
        if let vc = presentingViewController as? ToDoListViewController {
            vc.fetchData()
        }
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    // Adjust the input view according to keyboard
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            inputViewBottom.constant = adjustmentHeight
        }
        else {
            inputViewBottom.constant = 0
        }
    }
    
    // Dismissing keyboard if any touch occurs outside of view
    @IBAction func dismissKeyboard(_ sender: Any) {
        inputTask.resignFirstResponder()
    }
    
}
