//
//  ModalViewController.swift
//  ToDoList
//
//  Created by Güray Gül on 12.01.2024.
//

import UIKit

class ModalViewController: UIViewController {
    
    var task: ToDoList?
    var tasks = [ToDoList]()
    
    @IBOutlet weak var addTasks: UIView!
    
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var inputTask: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let toDoListManager = ToDoManager()
    var toDoListViewModel = TodoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Notifies the view if keyboard is open or close
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        updateUI()
        
        
    }
    
    func updateUI(){
        
        if toDoListViewModel.isEditingModeActive {
            submitButton.setTitle("EDIT", for: .normal)
        }
        else {
            submitButton.setTitle("ADD", for: .normal)
        }

        inputTask?.text = task?.name
        
    }
    
}

//MARK: - ACTIONS

extension ModalViewController {
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        toDoListViewModel.isEditingModeActive = false
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
        
        if toDoListViewModel.isEditingModeActive {
            task?.name = inputTask.text
            toDoListViewModel.updateTask(task ?? ToDoList())
        } else {
            toDoListViewModel.addTask(name: inputTask.text!, id: tasks.count, isDone: false)
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
