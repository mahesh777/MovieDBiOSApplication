//
//  PopularMovieAPIResponse.swift
//  MovieDBApplication
//
//  Created by Mahesh Sonaiya on 26/08/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class PopularMovieAPIResponse: NSObject {
    var page: Int? 
    var totalResults: Int?
    var totalPages: Int?
    var movieInfoArray: [MovieInfo]? = []
    
    
    required init(jsonDict: Dictionary<String, AnyObject>) {
        self.page = jsonDict["page"] as? Int
        self.totalResults = jsonDict["total_results"] as? Int
        self.totalPages = jsonDict["total_pages"] as? Int
        
        if let movieInfoList = jsonDict["results"] as? Array<Dictionary<String, AnyObject>> {
            for movieInfo in movieInfoList{
                let movieInfoObj = MovieInfo.init(jsonDict: movieInfo)
                self.movieInfoArray?.append(movieInfoObj)
            }
        }
    }
    
    func appendData(jsonDict: Dictionary<String, AnyObject>) {
        
        self.page = jsonDict["page"] as? Int
        self.totalResults = jsonDict["total_results"] as? Int
        self.totalPages = jsonDict["total_pages"] as? Int
        
        if let movieInfoList = jsonDict["results"] as? Array<Dictionary<String, AnyObject>> {
            for movieInfo in movieInfoList{
                let movieInfoObj = MovieInfo.init(jsonDict: movieInfo)
                self.movieInfoArray?.append(movieInfoObj)
            }
        }
    }
}
