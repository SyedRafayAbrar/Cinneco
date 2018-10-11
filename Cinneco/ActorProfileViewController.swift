//
//  ActorProfileViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 29/10/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import Alamofire

class ActorProfileViewController: UIViewController {

    var actor: Actor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getActorDetails()
    }

    func getActorDetails() {
        let actorDetailsUrl = SEARCH_ACTOR_DETAIL_URL + "\(actor.getId)" + "?api_key=\(MOVIEDB_API_KEY)"
        Alamofire.request(actorDetailsUrl).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let value = response.result.value as? [String: AnyObject] {
                    if let valueArray = value["results"] as? NSArray {
                        //print("ValueArray: ", valueArray)
                        for value in valueArray {
                            let data = value as! [String: AnyObject]
                            let actor = Actor(data: data)
                            //self.actorsArray.append(actor)
                            //self.tableView.reloadData()
                        }
                    }
                }
            case .failure(_):
                print("Error - Search Actor")
            }
        }
    }
}
