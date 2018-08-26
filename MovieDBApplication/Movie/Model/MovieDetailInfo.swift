//
//  MovieDetailInfo.swift
//  MovieDBApplication
//
//  Created by Mahesh Sonaiya on 26/08/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

public class MovieDetailInfo: MovieInfo {
    // MARK: - Properties
    var homepage: String? = ""
    var imdbId: Int? = 0
    var runtime: Int? = 0
    var voteAverage: Double? = 0.0
    var backdropPathWidthImage: String? 
    var backdropPathFullImage: String?
    
    override init() {
        super.init()
    }
    
    override init(jsonDict: Dictionary<String, AnyObject>) {
        super.init(jsonDict: jsonDict)
        self.homepage = jsonDict["homepage"] as? String
        self.imdbId = jsonDict["imdb_id"] as? Int
        self.runtime = jsonDict["runtime"] as? Int
        self.voteAverage = jsonDict["vote_average"] as? Double
        if let posterPath = jsonDict["backdrop_path"] as? String {
            self.backdropPathWidthImage = "https://image.tmdb.org/t/p/w500" + posterPath
            self.backdropPathFullImage = "https://image.tmdb.org/t/p/original" + posterPath
        }
    }
}
