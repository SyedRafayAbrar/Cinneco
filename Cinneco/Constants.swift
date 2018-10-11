//
//  Constants.swift
//  Cinneco
//
//  Created by Asher Ahsan on 01/09/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import Foundation
import UIKit

var SELECTED_MOVIE: Movie!

let COMBINED_CREDITS = "combined_credits"
let MOVIEDB_API_KEY = "36bdc526d2d6718ac3da5e000ff36b50"
let POPULAR_MOVIES_URL = "https://api.themoviedb.org/3/movie/popular?api_key=\(MOVIEDB_API_KEY)&language=en-US&page="
let GENERE_LIST_URL = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(MOVIEDB_API_KEY)&language=en-US"
let SEARCH_MOVIE_URL = "http://api.themoviedb.org/3/search/movie?api_key=\(MOVIEDB_API_KEY)"
let SEARCH_ACTOR_URL = "https://api.themoviedb.org/3/search/person?api_key=\(MOVIEDB_API_KEY)&query="
let SEARCH_ACTOR_DETAIL_URL = "https://api.themoviedb.org/3/person/"

let BLUE_COLOR = UIColor(red: 20/255, green: 189/255, blue: 237/255, alpha: 1.0)
let GREY_COLOR = UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 1.0)

var FEED_ACTION = ""

        // Setting TableView Identifiers



////let actorDetailsUrl = SEARCH_ACTOR_DETAIL_URL + "\(id)" + "?api_key=\(MOVIEDB_API_KEY)"

//let MOVIE_DETAILS_URL = "https://api.themoviedb.org/3/movie/177572?api_key=\(MOVIEDB_API_KEY)&language=en-US"
//let MOVIE_SUGGESTIONS_URL = "https://api.themoviedb.org/3/movie/"
//{movie_id}/recommendations?api_key=<<api_key>>&language=en-US&page=1
//let MOVIE_DIRECTOR_URL = "https://api.themoviedb.org/3/movie/177572/credits?api_key=36bdc526d2d6718ac3da5e000ff36b50&language=en-US"
//let MOVIE_REVIEWS_URL = "https://api.themoviedb.org/3/movie/177572/reviews?api_key=36bdc526d2d6718ac3da5e000ff36b50&language=en-US"

//let STARRING_NAME = "http://api.themoviedb.org/3/movie/\()/casts?api_key=\(MOVIEDB_API_KEY)"

//https://api.themoviedb.org/3/movie/popular?api_key=36bdc526d2d6718ac3da5e000ff36b50&language=en-US
