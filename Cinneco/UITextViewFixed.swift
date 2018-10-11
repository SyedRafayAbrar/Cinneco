//
//  UITextViewFixed.swift
//  Cinneco
//
//  Created by Asher Ahsan on 30/09/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit

@IBDesignable class UITextViewFixed: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
}
