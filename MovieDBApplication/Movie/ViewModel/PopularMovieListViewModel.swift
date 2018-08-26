//
//  PopularMovieListViewModel.swift
//  MovieDBApplication
//
//  Created by Mahesh Sonaiya on 25/08/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class PopularMovieListViewModel: NSObject {
    var movieInfoList: [MovieInfo]? = []
    var popularMovieAPIResponse : PopularMovieAPIResponse?
    
    func getListOfPopularMovie(pageIndex : Int,completionHandler:@escaping requestCompletionHandler) {
        
        MovieAPIRequestManager.sharedInstance.apiGetListOfPopularMovie(pageIndex) {
            [weak self] (feedResponse) -> Void in
            
            if feedResponse.error == nil {
                if let dictionary = feedResponse.responseDict as? Dictionary<String, AnyObject>{
                    if(pageIndex == 1) {
                        self?.popularMovieAPIResponse = PopularMovieAPIResponse.init(jsonDict:dictionary)
                    } else {
                        self?.popularMovieAPIResponse?.appendData(jsonDict: dictionary)
                    }
                }
                
            }
            completionHandler(feedResponse)
        }
    }
}

