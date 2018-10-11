//
//  ExploreViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 05/09/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import Alamofire

class ExploreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var moviesCarouse: iCarousel!
    @IBOutlet weak var mostWatching: iCarousel!
    @IBOutlet weak var recentRelease: iCarousel!
    
    
    var images = ["posterSample","posterSample","posterSample","posterSample","posterSample"]
    
    var genreArray = [Genre]()
    var genreToPass: Genre!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //start spinner
        
        Alamofire.request(GENERE_LIST_URL).responseJSON { response in
            if let value = response.result.value as? [String: AnyObject] {
                if let valueArray = value["genres"] as? NSArray {
                    for data in valueArray {
                        let genre = Genre(data: data as! [String : AnyObject])
                        self.genreArray.append(genre)
                        
                        self.tableView.reloadData()
                        //stop spinner
                    }
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.section == 0 {
            return 230
        }
        
        else if indexPath.section == 2{
            
            return 133.0
        }
        else {
            return 43.0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 || section == 0 {
            return 1
        }
        
        else if section == 1 {
            return genreArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if indexPath.section == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CarouselCell", for: indexPath) as! CarouselTableViewCell
                return cell
            
        }
        
        if indexPath.section == 2{
//                let cell = tableView.dequeueReusableCell(withIdentifier: "addMoreFriends", for: indexPath)
//                return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell") as! ExploreTableViewCell
            cell.configureCell(data: genreArray[indexPath.row])
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! ExploreTableViewCell
        genreToPass = cell.genre
        self.performSegue(withIdentifier: "genreSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "genreSegue" {
            let destVc = segue.destination as! GenreViewController
            destVc.genre = self.genreToPass
        }
    }
    
    
    @IBAction func searchBarPressed(_ sender: Any) {
        
        
    }
    
    
}
//extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//
//    //1
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 10
//    }
//
//    //2
//    func collectionView(_ collectionView: UICollectionView,
//                        numberOfItemsInSection section: Int) -> Int {
//        //        return searches[section].searchResults.count
//        return 10
//    }
//
//    //3
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreCollectionViewCell",
//                                                      for: indexPath) as! ExploreCollectionViewCell
//        //        cell.backgroundColor = UIColor.black
//        // Configure the cell
//        return cell
//    }
//}

extension ExploreViewController : iCarouselDataSource, iCarouselDelegate {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return images.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let tempView = UIView(frame: CGRect(x:0, y:0, width:90, height:80))
        //        tempView.backgroundColor = UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0)
        //        tempView.backgroundColor = UIColor.black
        
        let frame = CGRect(x:0, y:0, width:90, height:80)
        let imageView = UIImageView()
        imageView.frame = frame
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = UIImage(named: "\(images[index])")
        
        tempView.addSubview(imageView)
        
        return tempView
    }
    
//    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
//        if option == iCarouselOption.visibleItems {
//            return 2
//        }
//
//        if option == iCarouselOption.spacing {
//            print(value)
//
//            return value * 0.6
//        }
//        return value
//    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            print(value)
            
            return value * 0.5
        }
        
        if option == iCarouselOption.fadeMax {
            return 0.3
        }
        
        if option == iCarouselOption.fadeMin {
            return 0.3
        }
        if option == iCarouselOption.fadeRange {
            return 2
            
        }
        
        if option == iCarouselOption.fadeMinAlpha{
            return 0.3
        }
        
        if option == iCarouselOption.showBackfaces {
            return 2
        }
        
        if option == iCarouselOption.visibleItems {
            return 2
        }
        
        
        return value
    }
}


