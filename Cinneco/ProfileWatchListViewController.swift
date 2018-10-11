//
//  ProfileWatchListViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 06/09/2018.
//  Copyright © 2018 Asher Ahsan. All rights reserved.
//

import UIKit
import Alamofire

class ProfileWatchListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var watchlistMoviesArray = [Movie]()
    var movieData: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getWatchlistMovies()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    self.tableView.reloadData()
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlistMoviesArray.count
        //        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserWatchListCell") as! GeneralMovieTableViewCell
        //        cell.configureCell(movieData: moviesArray[indexPath.row])
        cell.configureCell(movieData: watchlistMoviesArray[indexPath.row])
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        //        self.tableView.isEditing = true
    //        tableView.deselectRow(at: indexPath, animated: true)
    //
    //        SELECTED_MOVIE = moviesArray[indexPath.row]
    //
    //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //        let controller = storyboard.instantiateViewController(withIdentifier: "IndividualMovieController")
    //        self.present(controller, animated: true, completion: nil)
    //    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 150
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  138
    }
    
    

}
