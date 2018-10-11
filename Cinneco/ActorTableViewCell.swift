//
//  ActorTableViewCell.swift
//  Cinneco
//
//  Created by Asher Ahsan on 29/10/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit

class ActorTableViewCell: UITableViewCell {

    @IBOutlet weak var actorProfileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var moviesLbl: UILabel!
    
    var actor: Actor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(actorData: Actor) {
        self.actor = actorData
        
        if let profileImagePath = actorData.getProfilePath {
            let imgUrl = URL(string: "http://image.tmdb.org/t/p/w342\(profileImagePath)")
            self.actorProfileImgView.kf.setImage(with: imgUrl, placeholder: #imageLiteral(resourceName: "sampleProfile"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        self.nameLbl.text = actorData.getName
        
    }
}
