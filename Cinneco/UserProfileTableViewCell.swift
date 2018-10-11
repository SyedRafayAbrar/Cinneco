//
//  UserProfileTableViewCell.swift
//  Cinneco
//
//  Created by Asher Ahsan on 27/10/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var watchlistBtn: UIButton!
    @IBOutlet weak var watchedBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(userData: User) {
        self.name.text = userData.getFullname
        self.descriptionLbl.text = userData.getDescription
        
        self.location.text = userData.getLocation
        
        if let websiteTxt = userData.getWebsite {
            self.website.text = websiteTxt
        } else {
            self.website.text = "N/A"
        }
        
        if let locationTxt = userData.getLocation {
            self.location.text = locationTxt
        } else {
            self.location.text = "Location not available"
        }
        
//        if let watchedCount = userData.getWatched {
//            let watchedTitle = "Watched (\(watchedCount.count))"
//            self.watchedBtn.setTitle(watchedTitle, for: .normal)
//        } else {
//            let watchedTitle = "Watched (0)"
//            self.watchedBtn.setTitle(watchedTitle, for: .normal)
//        }
        
//        if let watchlistCount = userData.getWatchlist {
//            let watchlistTitle = "Watchlist (\(watchlistCount.count))"
//            self.watchlistBtn.setTitle(watchlistTitle, for: .normal)
//        } else {
//            let watchlistTitle = "Watchlist (0)"
//            self.watchlistBtn.setTitle(watchlistTitle, for: .normal)
//        }
    }

}
