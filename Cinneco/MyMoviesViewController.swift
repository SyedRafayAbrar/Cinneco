//
//  MyMoviesViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 04/09/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class MyMoviesViewController: UIViewController {
    
    @IBOutlet weak var watched_count: UILabel!
    @IBOutlet weak var watchlist_count: UILabel!
    
    @IBOutlet weak var watchedCarousel: iCarousel!
    @IBOutlet weak var watchlistCarousel: iCarousel!
    
    @IBOutlet weak var WatchedSeeAll: UIButton!
    
    @IBOutlet weak var watchedCollectionView: UICollectionView!
    @IBOutlet weak var watchlistCollectionView: UICollectionView!
    
    @IBOutlet weak var watchedStackView: UIStackView!
    @IBOutlet weak var watchlistStackView: UIStackView!
    
    @IBOutlet weak var watchedLbl: UILabel!
    @IBOutlet weak var watchlistLbl: UILabel!
    
    @IBOutlet weak var spinner1: UIActivityIndicatorView!
    @IBOutlet weak var spinner2: UIActivityIndicatorView!
    
    
    @IBOutlet weak var activitySpinner1: UIActivityIndicatorView!
    @IBOutlet weak var activitySpinner2: UIActivityIndicatorView!
    
    var watchlistMoviesArray = [Movie]()
    var watchedMoviesArray = [Movie]()
    
    var movieData: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WatchedSeeAll.semanticContentAttribute = .forceRightToLeft
        watchedCarousel.reloadData()
        watchlistCarousel.reloadData()
        
        watchedCarousel.type = .rotary
        watchlistCarousel.type = .rotary
        
        //watchedCollectionView.delegate = self
        //watchedCollectionView.dataSource = self
        
        //watchlistCollectionView.delegate = self
        //watchlistCollectionView.dataSource = self
        
        let watchedTapGesture = UITapGestureRecognizer(target: self, action: #selector(openWatchedMoviesListAction))
        watchedStackView.addGestureRecognizer(watchedTapGesture)
        
        let watchlistTapGesture = UITapGestureRecognizer(target: self, action: #selector(openWatchlistAction))
        watchlistStackView.addGestureRecognizer(watchlistTapGesture)
        
        getWatchedMovies()
        getWatchlistMovies()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Getting movies
        //        getWatchedMovies()
        //        getWatchlistMovies()
    }
    
    func getWatchlistMovies() {
        //startSpinner(spinner: spinner2, collectionView: watchlistCollectionView)
        startSpinner(spinner: spinner2, carousel: watchlistCarousel)
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
                    self.watchlistCarousel.reloadData()
                    self.stopSpinner(spinner: self.spinner2, carousel: self.watchedCarousel)
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
    
    func getWatchedMovies() {
//        self.watchlistMoviesArray.removeAll()
           self.watchedMoviesArray.removeAll()
        DataService.instance.currentUserWatchedRef.observe(.childAdded, with: { (snapshot) in
            self.startSpinner(spinner: self.spinner1, carousel: self.watchedCarousel)
            let movieId = snapshot.key
            let movieRef = DataService.instance.movieRef.child(movieId)
            
            let url = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(MOVIEDB_API_KEY)&language=en-US"
            
            Alamofire.request(url).responseJSON { response in
                if let value = response.result.value as? [String: AnyObject] {
                    let data = value as! [String: AnyObject]
                    let movie = Movie(data: data)
                    self.watchedMoviesArray.append(movie)
                    print("Watched Movie Name: \(movie.getTitle)")
                    print("API Call Count \(self.watchedMoviesArray.count)")
                    self.stopSpinner(spinner: self.spinner1, carousel: self.watchedCarousel)
                    self.watchedCarousel.reloadData()
                    
                }
            }
            
            
//            movieRef.observeSingleEvent(of: .value, with: { (snapshot) in
//                guard let dictionary = snapshot.value as? [String: AnyObject] else {
//                    return
//                }
//                let movie = Movie(data: dictionary)
//                self.watchedMoviesArray.append(movie)
//                self.watchedCarousel.reloadData()
//            })
            
        })
        
    }
    
    func openWatchedMoviesListAction() {
        self.performSegue(withIdentifier: "watchedSegue", sender: self)
        
        
    }
    
    func openWatchlistAction() {
        self.performSegue(withIdentifier: "watchlistSegue", sender: self)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return CGSize(width: 120, height: 180)
    //    }
    
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        if collectionView == watchedCollectionView {
    //            watchedLbl.text = "Watched (\(watchedMoviesArray.count))"
    //            return watchedMoviesArray.count
    //        } else {
    //            watchlistLbl.text = "Watchlist (\(watchlistMoviesArray.count))"
    //            return watchlistMoviesArray.count
    //        }
    //    }
    
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        if collectionView == watchedCollectionView {
    //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "watchedCell", for: indexPath) as! MyMoviesCollectionViewCell
    //            cell.configureWatchedCell(movieData: watchedMoviesArray[indexPath.row])
    //            return cell
    //        } else if collectionView == watchlistCollectionView {
    //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "watchlistCell", for: indexPath) as! MyMoviesCollectionViewCell
    //            cell.configureWatchlistCell(movieData: watchlistMoviesArray[indexPath.row])
    //            return cell
    //        } else {
    //            return UICollectionViewCell()
    //        }
    //    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MyMoviesCollectionViewCell
        
        SELECTED_MOVIE = cell.movieData
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "IndividualMovieController")
        self.present(controller, animated: true, completion: nil)
        
        //self.performSegue(withIdentifier: "individualMovieSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "watchedSegue" {
            let destVc = segue.destination as! WatchedViewController
            destVc.moviesArray = self.watchedMoviesArray
        } else if segue.identifier == "watchlistSegue" {
            let destVc = segue.destination as! WatchlistViewController
            destVc.moviesArray = self.watchlistMoviesArray
        }
    }
    
    func startSpinner(spinner: UIActivityIndicatorView, carousel: iCarousel) {
        spinner.isHidden = false
        spinner.startAnimating()
        //        carousel.isHidden = true
    }
    
    func stopSpinner(spinner: UIActivityIndicatorView, carousel: iCarousel) {
        spinner.isHidden = true
        spinner.stopAnimating()
        //        carousel.isHidden = true
    }
    
    //    var images = ["posterSample","posterSample","posterSample","posterSample","posterSample","posterSample","posterSample","posterSample","posterSample","posterSample","posterSample","posterSample","posterSample","posterSample","posterSample","posterSample","posterSample","posterSample","posterSample","posterSample","posterSample","posterSample","posterSample","posterSample"]
    
    
    @IBAction func watched_seeAll(_ sender: Any) {
        openWatchedMoviesListAction()
    }
    
    @IBAction func watchlist_seeAll(_ sender: Any) {
        openWatchlistAction()
    }
}

extension MyMoviesViewController : iCarouselDataSource, iCarouselDelegate {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
       
       if (carousel == watchedCarousel) {
            print("Watched Count: \(watchedMoviesArray.count)")
            return watchedMoviesArray.count
        }
        else if (carousel == watchlistCarousel) {
            print("WatchList Count: \(watchlistMoviesArray.count)")
            return watchlistMoviesArray.count
        }
        else {
            return 0
        }
        
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        var tempView = UIView(frame: CGRect(x:0, y:0, width:120, height:80))
        
        if carousel == watchlistCarousel {
            tempView = UIView(frame: CGRect(x:0, y:0, width:100, height:80))
            //        tempView.backgroundColor = UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0)
            //        tempView.backgroundColor = UIColor.black
            
            let frame = CGRect(x:0, y:0, width:110, height:90)
            let posterView = UIImageView()
            posterView.frame = frame
            posterView.contentMode = .scaleAspectFill
            
            var path : String? = ""
            
            if carousel == watchlistCarousel {
                path = watchlistMoviesArray[index].getPosterPath
                if let path = path {
                    let url = URL(string: "http://image.tmdb.org/t/p/w342\(path)")
                    let non_optn = url!
                    print(url)
                    print(non_optn)
                    posterView.kf.setImage(with: non_optn, placeholder: #imageLiteral(resourceName: "loadingImg"), options: nil, progressBlock: nil, completionHandler: nil)
                    //             posterView.image = UIImage(named: "\(non_optn)")
                    
                    tempView.addSubview(posterView)
                }
            }
        }
        
        else if (carousel == watchedCarousel) {
            tempView = UIView(frame: CGRect(x:0, y:0, width:100, height:70))
            let frame = CGRect(x:0, y:0, width:110, height:80)
            let posterView = UIImageView()
            posterView.frame = frame
            posterView.contentMode = .scaleAspectFill
    
            if watchedMoviesArray.count > 0 {
                var path : String? = ""
                path = watchedMoviesArray[index].getPosterPath
                if let path = path {
                    let url = URL(string: "http://image.tmdb.org/t/p/w342\(path)")
                    let non_optn = url!
                    print(url)
                    print(non_optn)
                    posterView.kf.setImage(with: non_optn, placeholder: #imageLiteral(resourceName: "loadingImg"), options: nil, progressBlock: nil, completionHandler: nil)
                    //posterView.image = UIImage(named: "\(non_optn)")
                    
                    tempView.addSubview(posterView)
                }
            } else {
                print("No watched movies avaliable")
            }
        }
        
        let label = UILabel(frame: CGRect(x: 0, y:145, width: 110, height: 20))
        label.backgroundColor = UIColor.clear
        //label.font =  UIFont(name: "SF-Pro-Display-Thin", size: 2)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = label.font.withSize(10)
        tempView.addSubview(label)
        
//        var imagesLabel = watchlistMoviesArray[index].getTitle
//        label.text = imagesLabel
        return tempView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            //            print(value)
            return value * 1
        }
        
        if option == iCarouselOption.fadeMax {
            return 0
        }
        
        if option == iCarouselOption.fadeMin {
            return 0
            
        }
        if option == iCarouselOption.fadeRange {
            return 2.5
        }
        
        //if option == iCarouselOption.fadeMinAlpha{
        //return 0.3
        // }
        if option == iCarouselOption.showBackfaces {
            return 4
        }
        
        if option == iCarouselOption.visibleItems {
            return 10
        }
        
        
        return value
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        if carousel == watchedCarousel {
        }
    }
    
    func startSpinner(_sender: UIActivityIndicatorView ) {
        _sender.isHidden = false
        _sender.startAnimating()
    }
    
    func stopSpinner(_sender: UIActivityIndicatorView) {
        _sender.isHidden = true
        _sender.stopAnimating()
    }
}




