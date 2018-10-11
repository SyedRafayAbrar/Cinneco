//
//  CastCollectionViewCell.swift
//  Cinneco
//
//  Created by Asher Ahsan on 05/10/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userJob: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    func configureCell(userInfo: Credits) {
        if userInfo.getJob != nil { // crew
            if userInfo.getProfilePath != nil {
                let imgUrl = URL(string: "http://image.tmdb.org/t/p/w154\(userInfo.getProfilePath!)")
                userImageView.kf.setImage(with: imgUrl, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            } else {
                userImageView.image = #imageLiteral(resourceName: "loadingImg")
            }
            
            userName.text = userInfo.getName
            userJob.text = userInfo.getJob!
        } else { // cast
            if userInfo.getProfilePath != nil {
                let imgUrl = URL(string: "http://image.tmdb.org/t/p/w154\(userInfo.getProfilePath!)")
                userImageView.kf.setImage(with: imgUrl, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            } else {
                userImageView.image = #imageLiteral(resourceName: "loadingImg")
            }
            
            userName.text = userInfo.getName
            userJob.text = userInfo.getCharacter
        }
    }
}
