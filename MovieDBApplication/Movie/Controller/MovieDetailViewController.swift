//
//  MovieDetailViewController.swift
//  MovieDBApplication
//
//  Created by Mahesh Sonaiya on 25/08/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    // MARK: - IBOutlet properties
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieSubDetailsView: UIView!
    @IBOutlet weak var movieRuntimeImageView: UIImageView!
    @IBOutlet weak var movieRuntimeLabel: UILabel!
    @IBOutlet weak var movieRatingImageView: UIImageView!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieFavoriteButton: UIButton!
    
    // MARK: - View Model
    fileprivate var movieDetailsViewModel = MovieDetailViewModel()
    fileprivate var favoriteMovieViewModel = FavoriteMovieViewModel()
    
    // MARK: - UIViewController handling
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let movieId = movieDetailsViewModel.movieId {
            getMovieDetail(movieId: movieId)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open func setUpViewModel(viewModel : MovieDetailViewModel) {
        self.movieDetailsViewModel = viewModel
    }
    
    fileprivate func getMovieDetail(movieId : CLongLong) {
        if (GLOBAL.sharedInstance.isInternetReachable == false) {
            if let movieDetailInfo = self.movieDetailsViewModel.movieDetailInfo {
                self.populate(forFilmDetail: movieDetailInfo)
            }
            return
        }
        GLOBAL().showLoadingIndicatorWithMessage("Loading")
        
        movieDetailsViewModel.getMovieDetail(movieId: movieId) { [weak self] (movieAPIResponse) in
            
            DispatchQueue.main.async {
                GLOBAL().hideLoadingIndicator()
            }
            
            if movieAPIResponse.error == nil  {
                if self?.movieDetailsViewModel.movieDetailInfo != nil {
                    DispatchQueue.main.async {
                        self?.populate(forFilmDetail: (self?.movieDetailsViewModel.movieDetailInfo!)!)
                    }
                }
            } else {
                if let downloadError = movieAPIResponse.error{
                    DispatchQueue.main.async {
                        GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
                    }
                }
            }
        }
    }
    
    // MARK: - Populate Movie Details
    fileprivate func populate(forFilmDetail filmDetail: MovieDetailInfo) {
        UIView.animate(withDuration: 0.2) {
            self.movieSubDetailsView.alpha = 1.0
        }
        if let moviePosterPath = filmDetail.backdropPathWidthImage {
            moviePosterImageView.sd_setImage(with: URL.init(string: moviePosterPath), completed: nil)
        }
        
        if let runtime = filmDetail.runtime {
            self.movieRuntimeLabel.text = "\(runtime) min"
        }
            
        else {
            self.movieRuntimeLabel.text = " - "
        }
        
        self.movieRatingLabel.text = "\(filmDetail.voteAverage ?? 0.0)/10"
        self.navigationItem.title = filmDetail.title?.uppercased()
        self.movieOverviewLabel.text = filmDetail.overview
        
        setFavoriteUI(movieId: filmDetail.movieId)
    }
    
    // MARK:- Favorite Movie Click Event
    @IBAction func favoriteMovieClickEvent(_ sender : UIButton) {
        if let movieId = movieDetailsViewModel.movieDetailInfo?.movieId {
            if RealmDBManager.sharedInstance.isMovieExistInFavorites(movieId: movieId) {
                favoriteMovieViewModel.markAsFavoriteDetailView(isFavorite: false, movieDetailInfo: (self.movieDetailsViewModel.movieDetailInfo)!)
                setFavoriteUI(movieId: movieId)
            } else {
                favoriteMovieViewModel.markAsFavoriteDetailView(isFavorite: true, movieDetailInfo: (self.movieDetailsViewModel.movieDetailInfo)!)
                setFavoriteUI(movieId: movieId)
            }
        }
    }
    
    // MARK:- Set Favorite UI
    func setFavoriteUI(movieId : CLongLong?) {
        if let movieId = movieId {
            if RealmDBManager.sharedInstance.isMovieExistInFavorites(movieId: movieId) {
                movieFavoriteButton.setImage(UIImage.init(named: "ic_liked"), for: .normal)
                favoriteMovieViewModel.markAsFavoriteDetailView(isFavorite: true, movieDetailInfo: (self.movieDetailsViewModel.movieDetailInfo)!)
            } else {
                movieFavoriteButton.setImage(UIImage.init(named: "ic_dislike"), for: .normal)
            }
        } else {
            movieFavoriteButton.setImage(UIImage.init(named: "ic_dislike"), for: .normal)
        }
    }
}
