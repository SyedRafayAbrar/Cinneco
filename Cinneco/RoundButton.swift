//
//  RoundButton.swift
//  Cinneco
//
//  Created by TAMUR on 26/04/2018.
//  Copyright © 2018 Asher Ahsan. All rights reserved.
//

import UIKit

@IBDesignable

class RoundButton: UIButton {
    
    @IBInspectable var CornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = CornerRadius
        }
    }
    
    @IBInspectable var BorderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = BorderWidth
        }
    }
    
    @IBInspectable var BorderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = BorderColor.cgColor
        }
    }
}
