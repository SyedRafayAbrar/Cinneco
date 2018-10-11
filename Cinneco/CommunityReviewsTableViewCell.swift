//
//  CommunityReviewsTableViewCell.swift
//  Cinneco
//
//  Created by Asher Ahsan on 20/05/2018.
//  Copyright © 2018 Asher Ahsan. All rights reserved.
//

import UIKit

class CommunityReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var follower_image: UIImageView!
    
    @IBOutlet weak var review_description: UILabel!
    
    @IBOutlet weak var author_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
