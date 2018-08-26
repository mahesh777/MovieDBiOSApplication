//
//  MovieDetailViewModel.swift
//  MovieDBApplication
//
//  Created by Mahesh Sonaiya on 25/08/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class MovieDetailViewModel: NSObject {
    var movieDetailInfo : MovieDetailInfo?
    open var movieId : CLongLong?
    open var moviePosterPath : String?

    func getMovieDetail(movieId : CLongLong,completionHandler:@escaping requestCompletionHandler) {
        
        MovieAPIRequestManager.sharedInstance.apiGetMovieDetail(movieId) {
            [weak self] (feedResponse) -> Void in
            
            if feedResponse.error == nil {
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    self?.movieDetailInfo = MovieDetailInfo.init(jsonDict:dictionary)
                }
            }
            completionHandler(feedResponse)
        }
    }

}
