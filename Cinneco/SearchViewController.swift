//
//  SearchViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 22/10/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCategorySegmentControl: UISegmentedControl!
    
    var activitySpinner: UIActivityIndicatorView!
    
    var searchActive = false
    //var resultsArray = Array<Any>()
    var moviesArray = [Movie]()
    var actorsArray = [Actor]()
    var usersArray = [User]()
    
    var selectedActor: Actor!
    var selectedUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        searchBar.showsCancelButton = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func categoryChangeAction(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        self.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !(searchText.isEmpty) {
            if searchCategorySegmentControl.selectedSegmentIndex == 0 { //search movie
                var newSearchText = searchText
                if searchText.contains(" ") {
                    newSearchText = searchText.replacingOccurrences(of: " ", with: "+")
                }
                self.searchMovieInTMDB(searchString: newSearchText)
            } else if searchCategorySegmentControl.selectedSegmentIndex == 1 { //search actor
                var newSearchText = searchText
                if searchText.contains(" ") {
                    newSearchText = searchText.replacingOccurrences(of: " ", with: "+")
                }
                self.searchActorInTMDB(searchString: newSearchText)
            } else if searchCategorySegmentControl.selectedSegmentIndex == 2 { //search user
                self.searchUserInFirebase(searchString: searchText)
            }
        } else {
            moviesArray.removeAll()
            usersArray.removeAll()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if searchCategorySegmentControl.selectedSegmentIndex == 0 {
//            return moviesArray.count
//        } else {
//            return usersArray.count
//        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchCategorySegmentControl.selectedSegmentIndex == 0 {
            return 140
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchCategorySegmentControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieTableViewCell
//            cell.configureCell(movieData: moviesArray[indexPath.row])
            return cell
        } else if searchCategorySegmentControl.selectedSegmentIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "actorCell") as! ActorTableViewCell
//            cell.configureCell(actorData: actorsArray[indexPath.row])
            
            
            return cell
        } else if searchCategorySegmentControl.selectedSegmentIndex == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserTableViewCell
//            cell.configureCell(userData: usersArray[indexPath.row])
//            self.activitySpinner = cell.viewWithTag(20) as! UIActivityIndicatorView
            
            cell.userProfileImgView.layer.cornerRadius = cell.userProfileImgView.frame.size.width/2
            
            cell.userProfileImgView.clipsToBounds = true
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "IndividualMovieController")
        self.present(controller, animated: true, completion: nil)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        if searchCategorySegmentControl.selectedSegmentIndex == 0 {
////            SELECTED_MOVIE = moviesArray[indexPath.row]
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "IndividualMovieController")
//            self.present(controller, animated: true, completion: nil)
//        } else if searchCategorySegmentControl.selectedSegmentIndex == 1 {
//            let cell = tableView.cellForRow(at: indexPath) as! ActorTableViewCell
//            selectedActor = cell.actor
//            self.performSegue(withIdentifier: "userProfileSegue", sender: self)
//        } else if searchCategorySegmentControl.selectedSegmentIndex == 2 {
//            let cell = tableView.cellForRow(at: indexPath) as! UserTableViewCell
//            selectedUser = cell.user
//            self.performSegue(withIdentifier: "userProfileSegue", sender: self)
//        }
//    }
    
    func searchActorInTMDB(searchString: String) {
        actorsArray.removeAll()
        let searchActorUrl = SEARCH_ACTOR_URL + searchString
        Alamofire.request(searchActorUrl).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let value = response.result.value as? [String: AnyObject] {
                    if let valueArray = value["results"] as? NSArray {
                        //print("ValueArray: ", valueArray)
                        for value in valueArray {
                            let data = value as! [String: AnyObject]
                            let actor = Actor(data: data)
                            self.actorsArray.append(actor)
                            self.tableView.reloadData()
                        }
                    }
                }
            case .failure(_):
                print("Error - Search Actor")
            }
        }
    }
    
    func searchMovieInTMDB(searchString: String) {
        moviesArray.removeAll()
        let searchMovieUrl = SEARCH_MOVIE_URL + "&query=\(searchString)&page=1"
        Alamofire.request(searchMovieUrl).responseJSON { response in
            switch(response.result) {
            case .success(_):
                if let value = response.result.value as? [String: AnyObject] {
                    if let valueArray = value["results"] as? NSArray {
                        //print("ValueArray: ", valueArray)
                        for value in valueArray {
                            let data = value as! [String: AnyObject]
                            let movie = Movie(data: data)
                            self.moviesArray.append(movie)
                            self.tableView.reloadData()
                        }
                    }
                }
            case .failure(_):
                print("Error - Search Movie")
            }
        }
    }
    
    func searchUserInFirebase(searchString: String) {
        print("In Search User Firebase Function")
        DataService.instance.userRef.queryOrdered(byChild: "username").queryStarting(atValue: searchString).queryEnding(atValue: searchString + "\u{f8ff}").observeSingleEvent(of: .value, with: { (snapshot) in
            print("Snapshot Search: ", snapshot)
            self.usersArray.removeAll()
            let currentUserId = DataService.instance.currentUserID
            if snapshot.exists() {
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                for (i, userData) in  dictionary.values.enumerated() {
                    let key = Array(dictionary.keys)[i]
                    if key != currentUserId {
                        let user = User(id: key, data: userData as! [String : AnyObject])
                        self.usersArray.append(user)
                        self.tableView.reloadData()
                    }
                }
            } else {
                self.tableView.reloadData()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userProfileSegue" {
            let destVc = segue.destination as! UserProfileViewController
            destVc.user = selectedUser
        }
    }
    
    @IBAction func followUserAction(_ sender: UIButton) {
        let userCell = sender.superview?.superview?.superview as! UserTableViewCell
        let userId = userCell.user.getId
        let currentUserId = DataService.instance.currentUserID
        
        startSpinner(btn: sender)
        if sender.titleLabel?.text == "Follow" {
            //adding in followings ref
            DataService.instance.currentUserFollowingRef.updateChildValues([userId: true]) { (error, reference) in
                //adding in followed users follower ref
                DataService.instance.userRef.child(userId).child("follower").updateChildValues([currentUserId: true], withCompletionBlock: { (error, reference) in
                    self.stopSpinner(btn: sender)
                    sender.setTitle("Unfollow", for: .normal)
                    sender.backgroundColor = UIColor.black
                })
            }
        } else if sender.titleLabel?.text == "Unfollow" {
            //Removing user from current-user following-ref
            DataService.instance.currentUserFollowingRef.child(userId).removeValue(completionBlock: { (error, ref) in
                //Removing user from followed-user follower-ref
                DataService.instance.userRef.child(userId).child("follower").child(currentUserId).removeValue(completionBlock: { (error, ref) in
                    self.stopSpinner(btn: sender)
                    sender.setTitle("Follow", for: .normal)
                    sender.backgroundColor = BLUE_COLOR
                })
            })
        }
    }
    
    func startSpinner(btn: UIButton) {
        activitySpinner.isHidden = false
        activitySpinner.startAnimating()
        btn.isHidden = true
    }
    
    func stopSpinner(btn: UIButton) {
        activitySpinner.isHidden = true
        activitySpinner.stopAnimating()
        btn.isHidden = false
    }
}
