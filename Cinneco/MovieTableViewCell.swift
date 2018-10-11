//
//  MovieTableViewCell.swift
//  Cinneco
//
//  Created by Asher Ahsan on 22/10/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import Alamofire

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var starringLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(movieData: Movie) {
        if let posterPath = movieData.getPosterPath {
            let imgUrl = URL(string: "http://image.tmdb.org/t/p/w342\(posterPath)")
            self.posterImgView.kf.setImage(with: imgUrl, placeholder: #imageLiteral(resourceName: "loadingImg"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        self.titleLbl.text = movieData.getOriginalTitle
        setStarringLbl(movieId: movieData.getId)
    }

    func setStarringLbl(movieId: Int) {
        let STARRING_NAME_API = "http://api.themoviedb.org/3/movie/\(movieId)/casts?api_key=\(MOVIEDB_API_KEY)"
        Alamofire.request(STARRING_NAME_API).responseJSON { response in
            if let value = response.result.value as? [String: AnyObject] {
                if let valueArray = value["cast"] as? NSArray {
                    if valueArray.count > 0 {
                        let data = valueArray[0] as! [String: AnyObject]
                        let star = Star(data: data)
                        //self.starsArray.append(star)
                        self.starringLbl.text = star.getName
                    } else {
                        self.starringLbl.text = "N/A"
                    }
                }
            }
        }
    }
}
