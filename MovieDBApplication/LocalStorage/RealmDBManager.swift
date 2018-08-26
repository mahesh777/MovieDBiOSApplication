//
//  RealmDBManager.swift
//  MovieDBApplication
//
//  Created by Mahesh Sonaiya on 26/08/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDBManager : NSObject {
    static let sharedInstance = RealmDBManager()
    
    // MARK: Set Movie as favorite
    func setFavoriteMovie(movieDetail: MovieDetailInfo) {
        let realm = try! Realm()
        
        let movieMasterRealmModel = RealmMovieModel()
        
        movieMasterRealmModel.movieId = movieDetail.movieId!
        movieMasterRealmModel.movieTitle = movieDetail.title
        movieMasterRealmModel.originalTitle = movieDetail.originalTitle
        movieMasterRealmModel.posterPath = movieDetail.posterPath
        movieMasterRealmModel.backdropPathFullImage = movieDetail.backdropPathFullImage
        movieMasterRealmModel.backdropPathWidthImage = movieDetail.backdropPathWidthImage
        movieMasterRealmModel.overview = movieDetail.overview
        movieMasterRealmModel.releaseDate = movieDetail.releaseDate
        movieMasterRealmModel.runtime = movieDetail.runtime!
        
        try! realm.write {
            realm.add(movieMasterRealmModel, update:true)
        }
        try! realm.write {
            try! realm.commitWrite()
        }
    }
    
    // MARK: Remove Movie from favorites
    func removeFromFavorite(movieId : CLongLong) {
        let realm = try! Realm()
        realm.beginWrite()
        let filterMovieRealm = String.init(format: "movieId = %ld", movieId)
        
        let movieMasterRealmResults = realm.objects(RealmMovieModel.self).filter(filterMovieRealm)
        
        if movieMasterRealmResults.count > 0 {
            let movieMasterRealm = movieMasterRealmResults[0]
            realm.delete(movieMasterRealm)
            try! realm.commitWrite()
        }
    }
    
    // MARK: check movie exist in local DB
    func isMovieExistInFavorites(movieId : CLongLong) -> Bool {
        var isMovieFavorited = false
        
        let realm = try! Realm()
        
        let filterMovieRealm = String.init(format: "movieId = %ld", movieId)
        
        let movieMasterRealmResults = realm.objects(RealmMovieModel.self).filter(filterMovieRealm)
        
        if movieMasterRealmResults.count > 0 {
            isMovieFavorited = true
        }
        return isMovieFavorited
    }
    
    // MARK: Remove all favorites
    func deleteFavoriteMaster(){
        let realm = try! Realm()
        realm.beginWrite()
        let movieDetailMasterRealmResults = realm.objects(RealmMovieModel.self)
        realm.delete(movieDetailMasterRealmResults)
        try! realm.commitWrite()
        
    }
    
    // MARK: get movie favorites
    func getFavoriteMovies() -> [MovieDetailInfo] {
        let realm = try! Realm()
        
        var movieDetailMasterResults : [MovieDetailInfo] = []
        
        let movieDetailMasterRealmResults = realm.objects(RealmMovieModel.self)
        
        for index in 0 ..< movieDetailMasterRealmResults.count  {
            let movieDetailMasterRealm = movieDetailMasterRealmResults[index] as RealmMovieModel
            
            let movieDetail = MovieDetailInfo()
            
            movieDetail.movieId = movieDetailMasterRealm.movieId
            movieDetail.title = movieDetailMasterRealm.movieTitle
            movieDetail.originalTitle = movieDetailMasterRealm.originalTitle
            movieDetail.posterPath = movieDetailMasterRealm.posterPath
            movieDetail.backdropPathFullImage = movieDetailMasterRealm.backdropPathFullImage
            movieDetail.backdropPathWidthImage = movieDetailMasterRealm.backdropPathWidthImage
            movieDetail.overview = movieDetailMasterRealm.overview
            movieDetail.releaseDate = movieDetailMasterRealm.releaseDate
            movieDetail.runtime = movieDetailMasterRealm.runtime
            
            movieDetailMasterResults.append(movieDetail)
        }
        
        return movieDetailMasterResults
    }
    
}
