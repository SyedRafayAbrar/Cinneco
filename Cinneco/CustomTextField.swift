//
//  CustomTextField.swift
//  Cinneco
//
//  Created by Asher Ahsan on 26/08/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
    override func awakeFromNib() {
        updateView()
    }
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextFieldViewMode.always
            let container = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = image
            imageView.tintColor = UIColor(red: 205/255, green: 205/255, blue: 204/255, alpha: 1.0)
            imageView.contentMode = .scaleAspectFit
            
            container.addSubview(imageView)
            leftView = container
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSForegroundColorAttributeName: UIColor.white])
        // Border
        let color = UIColor.lightGray.cgColor
        self.layer.borderColor = color
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5
    }
}
