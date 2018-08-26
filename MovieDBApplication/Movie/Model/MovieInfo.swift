//
//  MovieInfo.swift
//  MovieDBApplication
//
//  Created by Mahesh Sonaiya on 26/08/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

public class MovieInfo: NSObject {
    var movieId: CLongLong?
    var title: String?
    var posterPath: String?
    var fullImagePath: String?
    var originalTitle: String?
    var releaseDate: String?
    var overview: String?
    
    override init() {}
    
    init(jsonDict: Dictionary<String, AnyObject>) {
        self.movieId = jsonDict["id"] as? CLongLong
        self.title = jsonDict["title"] as? String
        if let posterPath = jsonDict["poster_path"] as? String {
            self.posterPath = "https://image.tmdb.org/t/p/w500" + posterPath
            self.fullImagePath = "https://image.tmdb.org/t/p/original" + posterPath
        }
        self.originalTitle = jsonDict["original_title"] as? String
        self.releaseDate = jsonDict["release_date"] as? String
        self.overview = jsonDict["overview"] as? String
    }
}
