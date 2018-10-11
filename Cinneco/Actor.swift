//
//  Actor.swift
//  Cinneco
//
//  Created by Asher Ahsan on 28/10/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import Foundation

class Actor {
    private var id: Int!
    private var name: String!
    private var biography: String?
    private var gender: String?
    private var popularity: Double?
    private var placeOfBirth: String?
    private var profilePath: String?
    private var adult: Bool?
    private var imdbId: String?
    private var movies: [Movie]?
    
    var getId: Int {
        return self.id
    }
    
    var getName: String {
        return self.name
    }
    
    var getBiography: String? {
        return self.biography
    }
    
    var getGender: String? {
        return self.gender
    }
    
    var getPopularity: Double? {
        return self.popularity
    }
    
    var getplaceOfBirth: String? {
        return self.placeOfBirth
    }
    
    var getProfilePath: String? {
        return self.profilePath
    }
    
    var getAdult: Bool? {
        return self.adult
    }
    
    var getImdbId: String? {
        return self.imdbId
    }
    var getMovies: [Movie]? {
        return self.movies
    }
    
    init(data: [String: AnyObject]) {
        if data["id"] != nil {
            self.id = data["id"] as! Int
        } else {
            self.id = nil
        }
        
        if data["name"] != nil {
            self.name = data["name"] as! String
        } else {
            self.name = nil
        }
        
        if data["biography"] != nil {
            self.biography = data["biography"] as? String
        } else {
            self.biography = nil
        }
        
        if data["gender"] != nil {
            var gender = data["gender"] as! Int
            if gender == 1 {
                self.gender = "female"
            } else {
                self.gender = "male"
            }
        } else {
            self.gender = nil
        }
        
        if data["popularity"] != nil {
            self.popularity = data["popularity"] as? Double
        } else {
            self.popularity = nil
        }
        
        if data["place_of_birth"] != nil {
            self.placeOfBirth = data["place_of_birth"] as? String
        } else {
            self.placeOfBirth = nil
        }
        
        if data["profile_path"] != nil {
            self.profilePath = data["profile_path"] as? String
        } else {
            self.profilePath = nil
        }
        
        if data["adult"] != nil {
            self.adult = data["adult"] as? Bool
        } else {
            self.adult = nil
        }
        
        if data["imdb_id"] != nil {
            self.imdbId = data["imdb_id"] as? String
        } else {
            self.imdbId = nil
        }
        
        if data["known_for"] != nil {
            let moviesArrayTemp = data["known_for"] as? NSArray
            if let moviesArray = moviesArrayTemp {
                for eachMovie in moviesArray {
                    let movieDictionary = eachMovie as? [String: AnyObject]
                    if let dict = movieDictionary {
                        let movie = Movie(data: dict)
                        self.movies?.append(movie)
                    }
                }
            }
        } else {
            self.movies = nil
        }
    }
    
}
