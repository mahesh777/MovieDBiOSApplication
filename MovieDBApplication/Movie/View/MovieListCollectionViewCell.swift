//
//  MovieListCollectionViewCell.swift
//  MovieDBApplication
//
//  Created by Mahesh Sonaiya on 26/08/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet properties
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieFavoriteButton: UIButton!
    
    // MARK: - UICollectionViewCell life cycle
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.15)
    }
    
    // MARK: - Populate Cell
    func populate(withPosterPath posterPath: String?) {
        self.moviePosterImageView.image = nil
        if let posterPath = posterPath {
            self.moviePosterImageView.sd_setImage(with: URL.init(string: posterPath), completed: nil)
        }
    }
    
    func setFavoriteUI(movieId : CLongLong?) {
        if let movieId = movieId {
            if RealmDBManager.sharedInstance.isMovieExistInFavorites(movieId: movieId) {
                movieFavoriteButton.setImage(UIImage.init(named: "ic_liked"), for: .normal)
            } else {
                movieFavoriteButton.setImage(UIImage.init(named: "ic_dislike"), for: .normal)
            }
        } else {
            movieFavoriteButton.setImage(UIImage.init(named: "ic_dislike"), for: .normal)
        }
    }
}
