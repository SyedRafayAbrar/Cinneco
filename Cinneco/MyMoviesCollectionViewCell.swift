//
//  MyMoviesCollectionViewCell.swift
//  Cinneco
//
//  Created by Asher Ahsan on 04/09/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit

class MyMoviesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var watchedPosterImgView: UIImageView!
    @IBOutlet weak var watchedTitleLbl: UILabel!
    
    @IBOutlet weak var watchlistPosterImgView: UIImageView!
    @IBOutlet weak var watchlistTitleLbl: UILabel!
    
    var movieData: Movie!
    
    func configureWatchedCell(movieData: Movie) {
        self.movieData = movieData
        
        if let posterPath = movieData.getPosterPath {
            let url = URL(string: "http://image.tmdb.org/t/p/w342\(posterPath)")
            watchedPosterImgView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "loadingImg"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        watchedTitleLbl.text = movieData.getOriginalTitle
    }
    
    func configureWatchlistCell(movieData: Movie) {
        self.movieData = movieData
        
        if let posterPath = movieData.getPosterPath {
            let url = URL(string: "http://image.tmdb.org/t/p/w342\(posterPath)")
            watchlistPosterImgView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "loadingImg"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        watchlistTitleLbl.text = movieData.getOriginalTitle
    }
}
