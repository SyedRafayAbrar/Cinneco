//
//  ExploreTableViewCell.swift
//  Cinneco
//
//  Created by Asher Ahsan on 05/09/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import Alamofire

class ExploreTableViewCell: UITableViewCell {

    @IBOutlet weak var genreNameLbl: UILabel!
    @IBOutlet weak var movieCountLbl: UILabel!
    
    var genre: Genre!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(data: Genre) {
        self.genre = data
        
        getMovieCount(id: data.getId)
        
        self.genreNameLbl.text = data.getName
    }

    func getMovieCount(id: Int) {
        let url = "https://api.themoviedb.org/3/discover/movie?api_key=\(MOVIEDB_API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres=\(id)"
        
        Alamofire.request(url).responseJSON { response in
            if let value = response.result.value as? [String: AnyObject] {
                if let movieCount = value["total_results"] as? Int {
                    self.movieCountLbl.text = "(" + "\(movieCount)" + " Movies)"
                }
            }
        }
    }
}
