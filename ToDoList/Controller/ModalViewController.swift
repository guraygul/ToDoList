//
//  ModalViewController.swift
//  ToDoList
//
//  Created by Güray Gül on 12.01.2024.
//

import UIKit

class ModalViewController: UIViewController {
    
    var task = ToDoList()
    
    @IBOutlet weak var addTasks: UIView!
    
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var inputTask: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //modalPresentationStyle = .overCurrentContext
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

//MARK: - ACTIONS

extension ModalViewController{
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
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
        //print("\(keyboardFrame)")
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        inputTask.resignFirstResponder()
    }
    
}
