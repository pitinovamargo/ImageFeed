//
//  GradientView.swift
//  ImageFeed
//
//  Created by Margarita Pitinova on 28.03.2023.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }

    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        layer.frame = CGRect(x: 20, y: 113, width: 353, height: 30)
    }
}
