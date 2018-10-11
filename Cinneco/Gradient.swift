//
//  Gradient.swift
//  Cinneco
//
//  Created by Asher Ahsan on 02/07/2018.
//  Copyright © 2018 Asher Ahsan. All rights reserved.
//

import UIKit

@IBDesignable public class GradientView: UIView {
    
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureGradientLayer()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureGradientLayer()
    }
    
    func configureGradientLayer() {
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor.blue, UIColor.green]
    }
}
