//
//  RealmMovieModel.swift
//  MovieDBApplication
//
//  Created by Mahesh Sonaiya on 26/08/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import Foundation
import RealmSwift

class RealmMovieModel : Object {
    @objc dynamic var movieId : CLongLong = 0
    @objc dynamic var movieTitle : String?
    @objc dynamic var posterPath: String?
    @objc dynamic var originalTitle: String?
    @objc dynamic var releaseDate: String?
    @objc dynamic var overview: String?
    @objc dynamic var runtime: Int = 0
    @objc dynamic var voteAverage: Double = 0.0
    @objc dynamic var backdropPathWidthImage: String?
    @objc dynamic var backdropPathFullImage: String?
    
    @objc override static func primaryKey() -> String? {
        return "movieId"
    }
}
