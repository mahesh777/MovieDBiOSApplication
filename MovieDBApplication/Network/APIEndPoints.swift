//
//  APIEndPoints.swift
//  MovieDBApplication
//
//  Created by Mahesh Sonaiya on 25/08/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class APIEndPoints: NSObject {
    static func getBaseURL() -> String {
        return "https://api.themoviedb.org/3/"
    }
    
    static func getMovieModuleURL() -> String {
        return getBaseURL() + "movie/"
    }
    
    static func getPopularMovieListURL() -> String {
        return getMovieModuleURL() + "popular/"
    }
    
    static func getMovieDetailsURL(movieID : CLongLong) -> String {
        return getMovieModuleURL() + (String.init(format: "%ld", movieID))
    }
    
}
