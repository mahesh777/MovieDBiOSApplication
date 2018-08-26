//
//  MovieNetworkManager.swift
//  MovieDBApplication
//
//  Created by Mahesh Sonaiya on 26/08/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import Foundation

extension MovieAPIRequestManager {
    func apiGetListOfPopularMovie(_ pageIndex: Int,completionHandler:@escaping requestCompletionHandler) {
        
        var queryParameters: [String: String] = [:]
        
        queryParameters =   [UNTZAPIRequestKeys.pageIndex: String(pageIndex),
                             UNTZAPIRequestKeys.apiKey: APPLICATION.APIKey
        ]
        sendRequestWithURL(APIEndPoints.getPopularMovieListURL(), method: .get, queryParameters: queryParameters, bodyParameters: nil , headers: nil, isLoginHeaderRequired: false, completionHandler: completionHandler)
    }
    
    func apiGetMovieDetail(_ movieId: CLongLong,completionHandler:@escaping requestCompletionHandler) {
        
        var queryParameters: [String: String] = [:]
        
        queryParameters =   [UNTZAPIRequestKeys.apiKey: APPLICATION.APIKey]
        
        sendRequestWithURL(APIEndPoints.getMovieDetailsURL(movieID: movieId), method: .get, queryParameters: queryParameters, bodyParameters: nil , headers: nil, isLoginHeaderRequired: false, completionHandler: completionHandler)
    }
}
