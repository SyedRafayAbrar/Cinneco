//
//  GenreCollectionViewCell.swift
//  Cinneco
//
//  Created by Asher Ahsan on 05/10/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import Alamofire

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var genreBtn: UIButton!
    
    func configureCell(genre: Genre) {
        genreBtn.setTitle(genre.getName, for: .normal)
        
//        Alamofire.request(GENERE_LIST_URL).responseJSON { response in
//            if let value = response.result.value as? [String: AnyObject] {
//                if let valueArray = value["genres"] as? NSArray {
//                    for data in valueArray {
//                        let genre = Genre(data: data as! [String : AnyObject])
//                        self.genreBtn.setTitle(genre.getName, for: .normal)
//                    }
//                }
//            }
//        }
    }
}
