//
//  CarouselTableViewCell.swift
//  Cinneco
//
//  Created by Asher Ahsan on 08/06/2018.
//  Copyright © 2018 Asher Ahsan. All rights reserved.
//

import UIKit

class CarouselTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moviesCarouse: iCarousel!
    @IBOutlet weak var mostWatching: iCarousel!
    @IBOutlet weak var recentRelease: iCarousel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        recentRelease.type = .rotary
        recentRelease.isVertical = true
        
        moviesCarouse.type = .rotary
        moviesCarouse.isVertical = true
        
        mostWatching.type = .rotary
        mostWatching.isVertical = true
        
    }

}
