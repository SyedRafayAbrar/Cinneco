//
//  GeneralMovieTableViewCell.swift
//  Cinneco
//
//  Created by Asher Ahsan on 05/09/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire

class GeneralMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var moviePosterImgView: UIImageView!
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var starringLbl: UILabel!
    @IBOutlet weak var avgRatingStar: CosmosView!
    @IBOutlet weak var avgRatingLbl: UILabel!
    @IBOutlet weak var myRatingStar: CosmosView!
    
    var starsArray = [Star]()
    var movie: Movie!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        avgRatingStar.settings.fillMode = .half
        myRatingStar.settings.fillMode = .half
        myRatingStar.rating = 0.0

        starringLbl.text = ""

        myRatingStar.didFinishTouchingCosmos = { rating in
            let userId = DataService.instance.currentUserID
            let rating = rating

            DataService.instance.movieRef.child("\(self.movie.getId)").child("ratings").updateChildValues([userId: rating], withCompletionBlock: { (error, reference) in
                DataService.instance.currentUserWatchListRef.child("\(self.movie.getId)").removeValue(completionBlock: { (error, reference) in
                    DataService.instance.currentUserWatchedRef.child("\(self.movie.getId)").setValue(true)
                })

                if UserDefaults.standard.object(forKey: "USERNAME") != nil {
                    let username = UserDefaults.standard.string(forKey: "USERNAME")!
                    self.addToActivityLog(action: "\(username) rated \(rating) stars")
                }
            })
        }
    }
    
    func configureCell(movieData: Movie) {
        self.movie = movieData

        movieTitleLbl.text = movieData.getOriginalTitle
        setStarring(movieId: movieData.getId)

        //avgRatingLbl.text = String((movieData.getVoteAverage * 5)/10)
            //+ " - " + String(movieData.getVoteCount) + " Ratings"
        avgRatingStar.rating = (movieData.getVoteAverage * 5)/10

        getMyRating()

        if let posterPath = movieData.getPosterPath {
            let url = URL(string: "http://image.tmdb.org/t/p/w342\(posterPath)")
            
            print(url)
            
            moviePosterImgView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "loadingImg"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }

    func getMyRating() {
        let currId = DataService.instance.currentUserID
        DataService.instance.movieRef.child("\(movie.getId)").child("ratings").child(currId).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                self.myRatingStar.rating = (snapshot.value as! Double)
            } else {
                self.myRatingStar.rating = 0.0
            }
        })
    }
    
    func setStarring(movieId: Int) {
        let STARRING_NAME = "http://api.themoviedb.org/3/movie/\(movieId)/casts?api_key=\(MOVIEDB_API_KEY)"
        Alamofire.request(STARRING_NAME).responseJSON { response in
            if let value = response.result.value as? [String: AnyObject] {
              
                if let valueArray = value["cast"] as? [[String: AnyObject]] {
               
                    //for value in valueArray {
                    if valueArray.count != 0{
                    if let data = valueArray[0] as? [String: AnyObject]{
                        let star = Star(data: data)
                        if let name = data["name"] as? String{
                             self.starringLbl.text = name
                        }
                       
                    }
                        //self.starsArray.append(star)
                    }
                    //}
                }
            }
        }
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
