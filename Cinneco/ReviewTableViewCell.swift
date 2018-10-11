//
//  ReviewTableViewCell.swift
//  Cinneco
//
//  Created by Asher Ahsan on 26/04/2018.
//  Copyright © 2018 Asher Ahsan. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var comment_image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
