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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        modalPresentationStyle = .overCurrentContext
    }
    
}

//MARK: - ACTIONS

extension ModalViewController{
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
