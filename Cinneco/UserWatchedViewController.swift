//
//  UserWatchedViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 26/04/2018.
//  Copyright © 2018 Asher Ahsan. All rights reserved.
//

import UIKit
import Alamofire

class UserWatchedViewController: UIViewController {
    
    var watchlistMoviesArray = [Movie]()
    var watchedMoviesArray = [Movie]()
    
    var movieData: Movie!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getWatchlistMovies() {
        //startSpinner(spinner: spinner2, collectionView: watchlistCollectionView)
//        startSpinner(spinner: spinner2, carousel: watchlistCarousel)
        //        self.watchedMoviesArray.removeAll()
        self.watchlistMoviesArray.removeAll()
        
        //self.activitySpinner2.startAnimating()
        DataService.instance.currentUserWatchListRef.observe(.childAdded, with: { (snapshot) in
            let movieId = snapshot.key
            let movieRef = DataService.instance.movieRef.child(movieId)
            
            let url = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(MOVIEDB_API_KEY)&language=en-US"
            
            Alamofire.request(url).responseJSON { response in
                if let value = response.result.value as? [String: AnyObject] {
                    let data = value as! [String: AnyObject]
                    let movie = Movie(data: data)
                    self.watchlistMoviesArray.append(movie)
//                    self.watchlistCarousel.reloadData()
//                    self.stopSpinner(spinner: self.spinner2, carousel: self.watchedCarousel)
                }
            }
            //            movieRef.observeSingleEvent(of: .value, with: { (snapshot) in
            //                guard let dictionary = snapshot.value as? [String: AnyObject] else {
            //                    return
            //                }
            //                let movie = Movie(data: dictionary)
            //                self.watchlistMoviesArray.append(movie)
            //                self.stopSpinner(spinner: self.spinner2, carousel: self.watchedCarousel)
            //
            //                self.watchlistCarousel.reloadData()
            ////                self.watchlistCollectionView.reloadData()
            //                //self.spinner2.stopAnimating()
            //            })
            
        })
    }
}

extension UserWatchedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchedMoviesArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserWatchedCell", for: indexPath) as! UserWatchedTableViewCell
        return cell
    }
    
    
    
    
}
