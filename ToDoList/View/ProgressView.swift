//
//  ProgressView.swift
//  ToDoList
//
//  Created by Güray Gül on 31.01.2024.
//

import UIKit

class ProgressView: UIProgressView {
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height / 2)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskLayerPath.cgPath
        layer.mask = maskLayer
    }
}
