//
//  SuggestedMovieCollectionViewCell.swift
//  Cinneco
//
//  Created by Asher Ahsan on 05/10/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit

class SuggestedMovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var moviePosterImgView: UIImageView!
    
    func configureCell(movieInfo: Movie) {
        movieTitleLbl.text = movieInfo.getOriginalTitle
        
        if let posterPath = movieInfo.getPosterPath {
            let url = URL(string: "http://image.tmdb.org/t/p/w342\(posterPath)")
            moviePosterImgView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "loadingImg"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
}
