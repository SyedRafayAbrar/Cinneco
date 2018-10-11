//
//  FriendsTableViewCell.swift
//  Cinneco
//
//  Created by Asher Ahsan on 04/09/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher
import Alamofire

class FriendTableViewCell: UITableViewCell {

    //
    @IBOutlet weak var friendStatusLbl: UILabel!
    @IBOutlet weak var posterImgView: UIImageView!
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var starringLbl: UILabel!
    
    @IBOutlet weak var directorLbl: UILabel!
    
    @IBOutlet weak var avgRatingStars: CosmosView!
    @IBOutlet weak var myRatingsStars: CosmosView!
    
    var starsArray = [Star]()
    var movie: Movie!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
////        starringLbl.text = ""
//        avgRatingStars.settings.fillMode = .half
//        myRatingsStars.settings.fillMode = .half
//        myRatingsStars.rating = 0.0
//        
//        myRatingsStars.didFinishTouchingCosmos = { rating in
//            let userId = DataService.instance.currentUserID
//            let rating = rating
//            
//            DataService.instance.movieRef.child("\(self.movie.getId)").child("ratings").updateChildValues([userId: rating], withCompletionBlock: { (error, reference) in
//                DataService.instance.currentUserWatchListRef.child("\(self.movie.getId)").removeValue(completionBlock: { (error, reference) in
//                    DataService.instance.currentUserWatchedRef.child("\(self.movie.getId)").setValue(true)
//                })
//                
//                if UserDefaults.standard.object(forKey: "USERNAME") != nil {
//                    let username = UserDefaults.standard.string(forKey: "USERNAME")!
//                    self.addToActivityLog(action: "\(username) rated \(rating) stars")
//                }
//            })
//        }
//    }
    
    func configureCell(movieData: Movie) {
        
        self.movie = movieData
        
        friendStatusLbl.text = "mmcooper12 rated 3 stars"
        movieTitleLbl.text = movieData.getOriginalTitle
        setStarring(movieId: movieData.getId)
        
        //avgRatingsLbl.text = String((movieData.getVoteAverage * 5)/10) + " - " + String(movieData.getVoteCount) + " Ratings"
        avgRatingStars.rating = (movieData.getVoteAverage * 5)/10
        
        if let posterPath = movieData.getPosterPath {
            let url = URL(string: "http://image.tmdb.org/t/p/w342\(posterPath)")
            posterImgView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "loadingImg"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    func setStarring(movieId: Int) {
        let STARRING_NAME = "http://api.themoviedb.org/3/movie/\(movieId)/casts?api_key=\(MOVIEDB_API_KEY)"
        Alamofire.request(STARRING_NAME).responseJSON { response in
            if let value = response.result.value as? [String: AnyObject] {
                if let valueArray = value["cast"] as? NSArray {
                    for value in valueArray {
                        let data = value as! [String: AnyObject]
                        let star = Star(data: data)
                        self.starsArray.append(star)
                        self.starringLbl.text = self.starringLbl.text! + star.getName + ", "
                    }
                }
            }
        }
    }
    
    @IBAction func addBtnAction(_ sender: UIButton) {
        
    }
    
    func addToActivityLog(action: String) {
        //Add activity in current user activity-log
        let currentTime = Date().timeIntervalSince1970 * 1000
        let currentUserId = DataService.instance.currentUserID
        let activityId = DataService.instance.currentUserActivityLogRef.childByAutoId()
        let activityDetail = ["ownerId": currentUserId,
                              "movieId": "\(self.movie.getId)",
                              "action":  action, //FEED_ACTION,
            "timestamp": "\(currentTime)"] as [String : Any]
        
        activityId.updateChildValues(activityDetail) { (error, ref) in
            if error != nil {
                print("Feed Error")
            } else {
                //Add activity in all followers of current user news feed
                /*
                 DataService.instance.currentUserFollowerRef.observe(.childAdded, with: { (snapshot) in
                 let followerId = snapshot.key
                 let followerRef = DataService.instance.userRef.child(followerId)
                 
                 followerRef.child("newsFeed").updateChildValues([activityId.key: true])
                 self.stopSpinner(spinner: spinner, button: cellBtn)
                 })*/
            }
        }
    }
}
