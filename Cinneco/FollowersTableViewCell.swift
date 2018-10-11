//
//  FollowersTableViewCell.swift
//  Cinneco
//
//  Created by TAMUR on 26/04/2018.
//  Copyright © 2018 Asher Ahsan. All rights reserved.
//

import UIKit

class FollowersTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var follower_image: UIImageView!
    @IBOutlet weak var follower_name: UILabel!
    @IBOutlet weak var follower_hastag: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
