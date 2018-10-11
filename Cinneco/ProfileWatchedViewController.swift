//
//  ProfileWatchedViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 06/09/2018.
//  Copyright © 2018 Asher Ahsan. All rights reserved.
//

import UIKit
import  Alamofire

class ProfileWatchedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var watchedMoviesArray = [Movie]()
    var movieData: Movie!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//      watchedMoviesArray.removeAll()
        tableView.delegate = self
        tableView.dataSource = self
        
//        getWatchedMovies()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getWatchedMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWatchedMovies() {
        
        //self.watchlistMoviesArray.removeAll()
//        self.watchedMoviesArray.removeAll()
        DataService.instance.currentUserWatchedRef.observe(.childAdded, with: { (snapshot) in
//            self.startSpinner(spinner: self.spinner1, carousel: self.watchedCarousel)
            let movieId = snapshot.key
            let movieRef = DataService.instance.movieRef.child(movieId)
            
            let url = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(MOVIEDB_API_KEY)&language=en-US"
            
            Alamofire.request(url).responseJSON { response in
                if let value = response.result.value as? [String: AnyObject] {
//                    self.watchedMoviesArray.removeAll()
                    
                    let data = value as! [String: AnyObject]
                    let movie = Movie(data: data)
                    self.watchedMoviesArray.append(movie)
//                    self.tableView.reloadData()
//                    print("Watched Movie Name: \(movie.getTitle)")
//
//                    print("API Call Count \(self.watchedMoviesArray.count)")
                    
//                    self.stopSpinner(spinner: self.spinner1, carousel: self.watchedCarousel)
//                    self.watchedCarousel.reloadData()
                    
//                    if !self.watchedMoviesArray.isEmpty  // if your array is not empty refresh the tableview
//                    {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
//                        self.tableView.reloadData()
//                    })
//                    }
                    
                    
                }
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if !self.watchedMoviesArray.isEmpty  // if your array is not empty refresh the tableview
//        {
        print("Watched Movie Count \(watchedMoviesArray.count)")
          return watchedMoviesArray.count
//            }
//
//
//        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserWatchedCell") as! GeneralMovieTableViewCell
        
        print("Index Path: \(indexPath.row)")
//        print(watchedMoviesArray[indexPath.row].getOriginalName)
        
        //        cell.configureCell(movieData: moviesArray[indexPath.row])
        cell.configureCell(movieData: watchedMoviesArray[indexPath.row])
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
