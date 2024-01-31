//
//  ToDoCollectionViewCell.swift
//  ToDoList
//
//  Created by Güray Gül on 9.01.2024.
//

import UIKit

protocol ToDoCollectionViewCellDelegate: AnyObject {
    
    func didToggleCheckmark(for task: ToDoList)
}

class ToDoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var checkmarkButton: UIButton! {
        didSet {
            layer.cornerRadius = 20.0
        }
    }
    
    var task: ToDoList?
    weak var delegate: ToDoCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkmarkButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        
        // Set initial state for the checkmark
        updateCheckmark()
    }
    
    @objc func handleTap() {
        // Toggle the task's completion status
        task?.isDone.toggle()
        
        // Notify the delegate that the checkmark has been toggled
        delegate?.didToggleCheckmark(for: task!)
        
        // Save the data after toggling
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        // Update the checkmark
        updateCheckmark()
    }
    
    func updateCheckmark() {
        if let task = task {
            if task.isDone {
                checkmarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                checkmarkButton.tintColor = UIColor.green
            } else {
                checkmarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
                checkmarkButton.tintColor = UIColor.white
            }
        }
    }
    
}
