//
//  FavoriteMovieViewModel.swift
//  MovieDBApplication
//
//  Created by Mahesh Sonaiya on 26/08/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class FavoriteMovieViewModel: NSObject {
    func getListOfFavoriteMovies() -> [MovieDetailInfo]? {
        return RealmDBManager.sharedInstance.getFavoriteMovies()
    }
    
    func markAsFavoriteDetailView(isFavorite : Bool, movieDetailInfo : MovieDetailInfo) {
        if isFavorite == false {
            RealmDBManager.sharedInstance.removeFromFavorite(movieId: movieDetailInfo.movieId!)
        } else {
            RealmDBManager.sharedInstance.setFavoriteMovie(movieDetail: movieDetailInfo)
        }
    }
    
    func markAsFavoriteInfoView(isFavorite : Bool, movieInfo : MovieInfo) {
        if isFavorite == false {
            RealmDBManager.sharedInstance.removeFromFavorite(movieId: movieInfo.movieId!)
        } else {
            let movieDetailInfo = MovieDetailInfo.init()
            movieDetailInfo.movieId = movieInfo.movieId
            movieDetailInfo.title = movieInfo.title
            movieDetailInfo.posterPath = movieInfo.posterPath
            movieDetailInfo.releaseDate = movieInfo.releaseDate
            movieDetailInfo.overview = movieInfo.overview
            RealmDBManager.sharedInstance.setFavoriteMovie(movieDetail: movieDetailInfo)
        }
    }
}
