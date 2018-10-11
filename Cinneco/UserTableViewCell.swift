//
//  UserTableViewCell.swift
//  Cinneco
//
//  Created by Asher Ahsan on 22/10/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfileImgView: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var fullnameLbl: UILabel!
    
    var user: User!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(userData: User) {
        self.user = userData
        
        self.userProfileImgView.image = #imageLiteral(resourceName: "sampleProfile")
        self.usernameLbl.text = userData.getUsername
        self.fullnameLbl.text = userData.getFullname
    }
}
