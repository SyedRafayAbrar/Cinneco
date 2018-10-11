//
//  Movie.swift
//  Cinneco
//
//  Created by Asher Ahsan on 01/09/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import Foundation
import Alamofire

class Movie {
    private var id: Int!
    private var voteCount: Int!
    private var video: Bool!
    private var voteAverage: Double!
    private var title: String!
    private var popularity: Double!
    private var posterPath: String?
    private var originalLanguage: String!
    private var originalTitle: String?
    private var genres: [Genre]!
    private var backdropPath: String!
    private var adult: Bool!
    private var overview: String!
    private var releaseDate: String!
    private var budget: Int!
    private var runTime: Int!
    private var revenue: Int!
    private var productionCompany: [String]!
    private var credits: [Credits]!
    private var mpaaRating: String?
    private var originalName: String?
    
    var getId: Int {
        return self.id
    }
    
    var getVoteCount: Int {
        return self.voteCount
    }
    
    var getVideo: Bool {
        return self.video
    }
    
    var getVoteAverage: Double {
        return self.voteAverage
    }
    
    var getTitle: String {
        return self.title
    }
    
    var getPopularity: Double {
        return self.popularity
    }
    
    var getPosterPath: String? {
        return self.posterPath
    }
    
    var getOriginalLanguage: String {
        return self.originalLanguage
    }
    
    var getOriginalTitle: String? {
        return self.originalTitle
    }
    
    var getGenres: [Genre] {
        return self.genres
    }
    
    var getBackdropPath: String {
        return self.backdropPath
    }
    
    var getAdult: Bool {
        return self.adult
    }
    
    var getOverview: String {
        return self.overview
    }
    
    var getReleaseDate: String {
        return self.releaseDate
    }
    
    var getProductionCompany: [String] {
        return self.productionCompany
    }
    
    var getBudget: Int {
        return self.budget
    }
    
    var getRevenue: Int {
        return self.revenue
    }
    
    var getRuntime: Int {
        return self.runTime
    }
    
    var getCredits: [Credits] { 
        return self.credits
    }
    
    var getMpaaRating: String? {
        return self.mpaaRating
    }
    
    var getOriginalName: String? {
        return originalName
    }
    
    init(data: [String: AnyObject]) {
        if data["id"] != nil {
            self.id = data["id"] as? Int
        } else {
            self.id = nil
        }
        
        if data["vote_count"] != nil {
            self.voteCount = data["vote_count"] as? Int
        } else {
            self.voteCount = nil
        }
        
        if data["original_title"] != nil {
            self.originalTitle = data["original_title"] as? String
            self.originalName = nil
        } else if data["original_name"] != nil {
            self.originalTitle = nil
            self.originalName = data["original_name"] as? String
        } else {
            self.originalTitle = nil
            self.originalName = nil
        }
        
        if data["video"] != nil {
            self.video = data["video"] as? Bool
        } else {
            self.video = nil
        }
        
        if data["title"] != nil {
            self.title = data["title"] as? String
        } else {
            self.title = nil
        }
        
        if data["vote_average"] != nil {
            self.voteAverage = data["vote_average"] as? Double
        } else {
            self.voteAverage = nil
        }
        
        if data["popularity"] != nil {
            self.popularity = data["popularity"] as? Double
        } else {
            self.popularity = nil
        }
        
        
        
//        if data["poster_path"] != nil && !(data["poster_path"] is NSNull) {
//            self.posterPath = data["poster_path"] as? String
//        } else {
//            self.posterPath = nil
//        }
        
        if data["poster_path"] != nil {
            self.posterPath = data["poster_path"] as? String
        } else {
            self.posterPath = nil
        }
        
        if data["genres"] != nil || data["genre_ids"] != nil {
            let dataGenre: NSArray!
            if data["genres"] != nil {
                dataGenre = data["genres"] as! NSArray
                for eachGenre in dataGenre {
                    let genre = Genre(data: eachGenre as! [String: AnyObject])
                    if self.genres != nil {
                        self.genres.append(genre)
                    } else {
                        self.genres = [genre]
                    }
                }
            } else {
                dataGenre = data["genre_ids"] as! NSArray
                if dataGenre.count > 0 {
                    Alamofire.request(GENERE_LIST_URL).responseJSON
                        
                        { response in
                            
                        if let value = response.result.value as? [String: AnyObject] {
                            if let valueArray = value["genres"] as? NSArray {
                                for data in valueArray {
                                    let genre = Genre(data: data as! [String : AnyObject])
                                    if genre.getId == dataGenre[0] as! Int {
                                        if self.genres != nil {
                                            self.genres.append(genre)
                                        } else {
                                            self.genres = [genre]
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            self.genres = nil
        }
        
        if data["backdrop_path"] != nil {
            self.backdropPath = data["backdrop_path"] as? String
        } else {
            self.backdropPath = nil
        }
        
        if data["adult"] != nil {
            self.adult = data["adult"] as? Bool
        } else {
            self.adult = nil
        }
        
        if data["overview"] != nil {
            self.overview = data["overview"] as? String
        } else {
            self.overview = nil
        }
        
        if data["release_date"] != nil {
            self.releaseDate = data["release_date"] as? String
        } else {
            self.releaseDate = nil
        }
        
        if data["production_companies"] != nil {
            let productionCompanies = data["production_companies"] as! [AnyObject]
            productionCompany = [String]()
            productionCompanies.forEach({ (company) in
                productionCompany.append(company["name"] as! String)
            })
        } else {
            self.productionCompany = nil
        }
        
        if data["budget"] != nil {
            self.budget = data["budget"] as? Int
        } else {
            self.budget = nil
        }
        
        if data["revenue"] != nil {
            self.revenue = data["revenue"] as? Int
        } else {
            self.revenue = nil
        }
        
        if data["runtime"] != nil {
            self.runTime = data["runtime"] as? Int
        } else {
            self.runTime = nil
        }
        
        if data["credits"] != nil {
            let credits = data["credits"] as! [String: AnyObject]
            let casts = credits["cast"] as! NSArray
            casts.forEach({ (cast) in
                let credit = Credits(data: cast as! [String: AnyObject])
                if self.credits != nil {
                    self.credits.append(credit)
                } else {
                    self.credits = [credit]
                }
            })
            
            let crews = credits["crew"] as! NSArray
            crews.forEach({ (crew) in
                let credit = Credits(data: crew as! [String: AnyObject])
                if self.credits != nil {
                    self.credits.append(credit)
                } else {
                    self.credits = [credit]
                }
            })
        } else {
            self.credits = nil
        }
        
        if data["release_dates"] != nil {
            let mpaa = data["release_dates"] as! [String: AnyObject]
            let results = mpaa["results"] as! NSArray
            
            results.forEach({ (eachResult) in
                let result = eachResult as! [String: AnyObject]
                let country = result["iso_3166_1"] as! String
                if country == "US" {
                    let objects = result["release_dates"] as! NSArray
                    objects.forEach({ (eachObject) in
                        let object = eachObject as! [String: AnyObject]
                        let rating = object["certification"] as! String
                        self.mpaaRating = rating
                    })
                }
            })
        } else {
            self.mpaaRating = "N/A"
        }
    }
}
