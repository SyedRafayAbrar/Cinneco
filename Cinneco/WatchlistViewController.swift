//
//  WatchlistViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 09/09/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import Cosmos

class WatchlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchController: UISearchBar!
    var moviesArray = [Movie]()
//    var ratedMovies = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
//        let textFieldInsideSearchBar = searchController.value(forKey: "searchField") as? UITextField
//
//        textFieldInsideSearchBar?.textColor = UIColor.white
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
//        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "watchlistCell") as! GeneralMovieTableViewCell
        cell.configureCell(movieData: moviesArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        SELECTED_MOVIE = moviesArray[indexPath.row]
        let storyboard = UIStoryboard(name: "MyMovies", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "IndividualMovieController")
        self.present(controller, animated: true, completion: nil)
    }
}
