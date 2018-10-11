//
//  PageViewCell.swift
//  Cinneco
//
//  Created by Asher Ahsan on 05/05/2018.
//  Copyright © 2018 Asher Ahsan. All rights reserved.
//

import UIKit
import PageMenu

class PageViewCell: UITableViewCell {
    
    var pageMenu: CAPSPageMenu?
    
    @IBOutlet weak var widthPageMenu: NSLayoutConstraint!
    @IBOutlet weak var pageMenuView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
