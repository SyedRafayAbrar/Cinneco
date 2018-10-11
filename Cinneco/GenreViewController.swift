//
//  GenreViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 05/09/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class GenreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderByBtn: UIButton!
    @IBOutlet weak var orderBtn: UIButton!
    
    var genre: Genre!
    var movieArray = [Movie]()
    var keysArray = [String]()
    
    var sortedArray = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        self.navigationItem.title = "\(genre.getName!)"
    
        tableView.delegate = self
        tableView.dataSource = self
        
        let url = "https://api.themoviedb.org/3/discover/movie?api_key=\(MOVIEDB_API_KEY)&language=en-US&page=1&with_genres=\(genre.getId!)"
        
        //let url = "https://api.themoviedb.org/3/discover/movie?api_key=\(MOVIEDB_API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres=\(genre.getId!)"
        
        //start spinner
        
        Alamofire.request(url).responseJSON { response in
            //print("Response: ", response)
            if let value = response.result.value as? [String: AnyObject] {
                if let valueArray = value["results"] as? NSArray {
                    for value in valueArray {
                        let data = value as! [String: AnyObject]
                        let movieId = data["id"] as! Int
                        self.getMovieDetail(movieId: movieId)
                        //stop spinner
                    }
                }
            }
        }
    }
    
    func getMovieDetail(movieId: Int) {
        let movieDetailUrl = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(MOVIEDB_API_KEY)"
        
        Alamofire.request(movieDetailUrl).responseJSON { (response) in
            if let value = response.result.value as? [String: AnyObject] {
                let data = value as! [String: AnyObject]
                let movie = Movie(data: data)
                self.movieArray.append(movie)
                print("MovieName: ", movie.getOriginalTitle)
                print("RuntTime: ", movie.getRuntime)
                self.tableView.reloadData()
                
                //need closure to reload tableview alphabatically
                //self.orderBy(flag: 0, innerFlag: 0)
                //stop spinner
            }
        }
    }
    
    @IBAction func sortOrderBtnAction(_ sender: UIButton) {
        print("ABC")
        switch orderByBtn.tag {
        case 0:
            orderBy(flag: 0, innerFlag: sender.tag)
            if sender.tag == 0 {
                sender.tag = 1
            } else {
                sender.tag = 0
            }
        case 1:
            orderBy(flag: 1, innerFlag: sender.tag)
            if sender.tag == 0 {
                sender.tag = 1
            } else {
                sender.tag = 0
            }
        case 2:
            orderBy(flag: 2, innerFlag: sender.tag)
            if sender.tag == 0 {
                sender.tag = 1
            } else {
                sender.tag = 1
            }
        case 3:
            orderBy(flag: 3, innerFlag: sender.tag)
            if sender.tag == 0 {
                sender.tag = 1
            } else {
                sender.tag = 0
            }
        case 4:
            orderBy(flag: 4, innerFlag: sender.tag)
            if sender.tag == 0 {
                sender.tag = 1
            } else {
                sender.tag = 0
            }
        default:
            break
        }
        
        tableView.reloadData()
    }
    
    func orderBy(flag: Int, innerFlag: Int) {
        // 0 = alphabetical
        // 1 = avg rating
        // 2 = number of ratings
        // 3 = release date
        // 4 = run time
        
//        switch flag {
//        case 0:
//            if innerFlag == 0 { //ascending
//                movieArray = self.movieArray.sorted {
//                    $0.getOriginalTitle! < $1.getOriginalTitle!
//                }
//                orderBtn.setImage(#imageLiteral(resourceName: "upArrow"), for: .normal)
//            } else { //descending
//                movieArray = self.movieArray.sorted {
//                    $0.getOriginalTitle! > $1.getOriginalTitle!
//                }
//                orderBtn.setImage(#imageLiteral(resourceName: "downArrow-1"), for: .normal)
//            }
//        case 1:
//            if innerFlag == 0 {
//                movieArray = self.movieArray.sorted {
//                    $0.getVoteAverage < $1.getVoteAverage
//                }
//                orderBtn.setImage(#imageLiteral(resourceName: "upArrow"), for: .normal)
//            } else {
//                movieArray = self.movieArray.sorted {
//                    $0.getVoteAverage > $1.getVoteAverage
//                }
//                orderBtn.setImage(#imageLiteral(resourceName: "downArrow-1"), for: .normal)
//            }
//        case 2:
//            if innerFlag == 0 {
//                movieArray = self.movieArray.sorted {
//                    $0.getVoteCount < $1.getVoteCount
//                }
//                orderBtn.setImage(#imageLiteral(resourceName: "upArrow"), for: .normal)
//            } else {
//                movieArray = self.movieArray.sorted {
//                    $0.getVoteCount > $1.getVoteCount
//                }
//                orderBtn.setImage(#imageLiteral(resourceName: "downArrow-1"), for: .normal)
//            }
//        case 3:
//            if innerFlag == 0 {
//                movieArray = self.movieArray.sorted {
//                    $0.getReleaseDate < $1.getReleaseDate
//                }
//                orderBtn.setImage(#imageLiteral(resourceName: "upArrow"), for: .normal)
//            } else {
//                movieArray = self.movieArray.sorted {
//                    $0.getReleaseDate > $1.getReleaseDate
//                }
//                orderBtn.setImage(#imageLiteral(resourceName: "downArrow-1"), for: .normal)
//            }
//        case 4:
//            if innerFlag == 0 {
//                movieArray = self.movieArray.sorted {
//                    $0.getRuntime < $1.getRuntime
//                }
//                orderBtn.setImage(#imageLiteral(resourceName: "upArrow"), for: .normal)
//            } else {
//                movieArray = self.movieArray.sorted {
//                    $0.getRuntime > $1.getRuntime
//                }
//                orderBtn.setImage(#imageLiteral(resourceName: "downArrow-1"), for: .normal)
//            }
//        default:
//            break
//        }
    }
    
    @IBAction func sortbyBtnAction(_ sender: UIButton) {
        //present action sheet
        let actionSheetController = UIAlertController(title: "Sort By", message: "", preferredStyle: .actionSheet)
        
        let alphabeticallyOrdered = UIAlertAction(title: "Alphabetically", style: .default) { (action) in
            //sort array alphabetically
//            self.orderBy(flag: 0, innerFlag: 0)
            sender.setTitle("Alphabetically", for: .normal)
            sender.tag = 0
            self.orderBtn.setImage(#imageLiteral(resourceName: "upArrow"), for: .normal)
            self.tableView.reloadData()
        }
        
        let avgRatingOrdered = UIAlertAction(title: "Avg. Rating", style: .default) { (action) in
            //sort array avg rated
//            self.orderBy(flag: 1, innerFlag: 0)
            sender.setTitle("Avg. Rating", for: .normal)
            sender.tag = 1
            self.orderBtn.setImage(#imageLiteral(resourceName: "upArrow"), for: .normal)
            self.tableView.reloadData()
        }
        
        let dateAddedOrdered = UIAlertAction(title: "Date Added", style: .default) { (action) in
            //sort array date added
            //orderBy(flag: 0)
            //sender.setTitle("Date Added", for: .normal)
            //tableView.reloadData()
        }
        
        let numberOfRatingOrdered = UIAlertAction(title: "Number of Ratings", style: .default) { (action) in
            //sort array number of rating
//            self.orderBy(flag: 2, innerFlag: 0)
            sender.setTitle("Number of Ratings", for: .normal)
            sender.tag = 2
            self.orderBtn.setImage(#imageLiteral(resourceName: "upArrow"), for: .normal)
            self.tableView.reloadData()
        }
        
        let releasedDateOrdered = UIAlertAction(title: "Release Date", style: .default) { (action) in
            //sort array release date
//            self.orderBy(flag: 3, innerFlag: 0)
            sender.setTitle("Release Date", for: .normal)
            sender.tag = 3
            self.orderBtn.setImage(#imageLiteral(resourceName: "upArrow"), for: .normal)
            self.tableView.reloadData()
        }
        
        let runTimeOrdered = UIAlertAction(title: "Run Time", style: .default) { (action) in
            //sort array run time
//            self.orderBy(flag: 4, innerFlag: 0)
            sender.setTitle("Run Time", for: .normal)
            sender.tag = 4
            self.orderBtn.setImage(#imageLiteral(resourceName: "upArrow"), for: .normal)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheetController.addAction(alphabeticallyOrdered)
        actionSheetController.addAction(avgRatingOrdered)
        //actionSheetController.addAction(dateAddedOrdered)
        actionSheetController.addAction(numberOfRatingOrdered)
        actionSheetController.addAction(releasedDateOrdered)
        actionSheetController.addAction(runTimeOrdered)
        
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell") as! GeneralMovieTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath)
//        cell.configureCell(movieData: movieArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        SELECTED_MOVIE = movieArray[indexPath.row]
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "IndividualMovieController")
//        self.present(controller, animated: true, completion: nil)
    }
}
