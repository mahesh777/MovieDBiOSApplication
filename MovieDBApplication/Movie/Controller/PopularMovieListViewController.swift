//
//  ViewController.swift
//  MovieDBApplication
//
//  Created by Mahesh Sonaiya on 25/08/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit


class PopularMovieListViewController: UIViewController {
    // MARK: - IBOutlet properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    //@IBOutlet weak var noresultLabel: UILabel!
    
    fileprivate let refreshControl: UIRefreshControl = UIRefreshControl()
    
    // MARK: - UICollectionViewCell layout properties
    fileprivate let cellIdentifier : String = "MovieListCollectionViewCell"
    fileprivate static var posterRatio: CGFloat = (2.0 / 3.0)
    fileprivate var collectionViewItemsPerRow: Int = 2
    fileprivate let collectionViewMargin: CGFloat = 15.0
    fileprivate let collectionViewItemSizeRatio: CGFloat = posterRatio
    fileprivate var collectionViewItemWidth: CGFloat {
        return (self.collectionView.bounds.width - (CGFloat(self.collectionViewItemsPerRow + 1) * self.collectionViewMargin)) / CGFloat(self.collectionViewItemsPerRow)
    }
    fileprivate var collectionViewItemHeight: CGFloat {
        return self.collectionViewItemWidth / self.collectionViewItemSizeRatio
    }
    fileprivate func itemsPerRow(for size: CGSize) -> Int {
        if size.width > 768 {
            return 4
        }
        else if size.width > 414 {
            return 3
        }
        else { return 2 }
    }
    
    // MARK: - View Model
    fileprivate let popularMovieViewModel = PopularMovieListViewModel()
    fileprivate var favoriteMovieViewModel = FavoriteMovieViewModel()
    fileprivate var isDataLoading = false
    
    // MARK: - UIViewController handling
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Popular Movies"
        setupUI()
        hitAPIRequest(isFirstTime: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionViewItemsPerRow = self.itemsPerRow(for: UIScreen.main.bounds.size)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI Setup
    
    fileprivate func setupUI() {
        let favoritedButton = UIBarButtonItem.init(title: "Favorited", style: .plain, target: self, action: #selector(self.goToFavoriteView))
        self.navigationItem.rightBarButtonItem  = favoritedButton
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        self.collectionView.register(UINib.init(nibName: "MovieListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.addSubview(self.refreshControl)
    }
    
    fileprivate func hitAPIRequest(isFirstTime : Bool) {
        if isFirstTime {
            //self.noresultLabel.isHidden = true
            getPopularMovieList(pageIndex: 1)
        } else {
            getPopularMovieList(pageIndex: (popularMovieViewModel.popularMovieAPIResponse?.page)! + 1)
        }
    }
    
    fileprivate func getPopularMovieList(pageIndex : Int) {
        if pageIndex == 1 {
            GLOBAL().showLoadingIndicatorWithMessage("Loading")
        }
        self.isDataLoading = true
        popularMovieViewModel.getListOfPopularMovie(pageIndex: pageIndex) { [weak self] (movieAPIResponse) in
            
            DispatchQueue.main.async {
                GLOBAL().hideLoadingIndicator()
            }
            
            if movieAPIResponse.error == nil  {
                if self?.popularMovieViewModel.popularMovieAPIResponse?.movieInfoArray?.count == 0 {
                    DispatchQueue.main.async {
                        //self?.noresultLabel.isHidden = false
                        self?.collectionView.reloadData()
                    }
                }else{
                    DispatchQueue.main.async {
                        //self?.noresultLabel.isHidden = true
                        self?.collectionView.reloadData()
                    }
                }
            } else {
                if let downloadError = movieAPIResponse.error{
                    DispatchQueue.main.async {
                        GLOBAL().showAlert(APPLICATION.applicationName, message: downloadError.localizedDescription, actions: nil)
                    }
                }
            }
            self?.isDataLoading = false
        }
    }
}

extension PopularMovieListViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath) as! MovieListCollectionViewCell
        // Configure the cell
        let movie = popularMovieViewModel.popularMovieAPIResponse?.movieInfoArray![indexPath.row]
        cell.populate(withPosterPath: movie?.posterPath)
        cell.setFavoriteUI(movieId: movie?.movieId)
        
        cell.movieFavoriteButton.tag = indexPath.row
        cell.movieFavoriteButton .addTarget(self, action: #selector(self.favoriteMovieClickEvent(_:)), for: .touchUpInside)

        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let moveilist = popularMovieViewModel.popularMovieAPIResponse?.movieInfoArray {
            return moveilist.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = popularMovieViewModel.popularMovieAPIResponse?.movieInfoArray![indexPath.row]
        goToDetailView(movieInfo: movie)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewItemWidth, height: self.collectionViewItemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.collectionViewMargin, left: self.collectionViewMargin, bottom: self.collectionViewMargin, right: self.collectionViewMargin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.collectionViewMargin
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let moveilist = popularMovieViewModel.popularMovieAPIResponse?.movieInfoArray {
            if (indexPath.row == moveilist.count - 5) {
                if isDataLoading == false {
                    isDataLoading = true
                    hitAPIRequest(isFirstTime: false)
                }
            }
        }
    }
    
    // MARK:- Favorite Movie Click Event
    @objc func favoriteMovieClickEvent(_ sender : UIButton) {
        let rowIndex = sender.tag
        if let movieInfoList = popularMovieViewModel.popularMovieAPIResponse?.movieInfoArray {
            let movieInfo = movieInfoList[rowIndex]
            if let movieId = movieInfo.movieId {
                if RealmDBManager.sharedInstance.isMovieExistInFavorites(movieId: movieId) {
                    favoriteMovieViewModel.markAsFavoriteInfoView(isFavorite: false, movieInfo: movieInfo)
                    setFavoriteUI(movieId: movieId, movieFavoriteButton: sender)
                } else {
                    favoriteMovieViewModel.markAsFavoriteInfoView(isFavorite: true, movieInfo: movieInfo)
                    setFavoriteUI(movieId: movieId, movieFavoriteButton: sender)
                }
            }
        }
        
    }
    
    // MARK:- Set Favorite UI
    func setFavoriteUI(movieId : CLongLong?, movieFavoriteButton : UIButton) {
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
    
    // MARK:- Go To Detail View
    func goToDetailView(movieInfo : MovieInfo?) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = storyBoard.instantiateViewController(withIdentifier: "idMovieDetailVC") as! MovieDetailViewController
        let viewModel = MovieDetailViewModel.init()
        viewModel.movieId = movieInfo?.movieId
        viewModel.moviePosterPath = movieInfo?.posterPath
        detailsViewController.setUpViewModel(viewModel: viewModel)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    // MARK:- Go To Favorites View
    @objc func goToFavoriteView() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let favoriteMoviesViewController = storyBoard.instantiateViewController(withIdentifier: "idFavoriteVC") as! FavoriteMoviesViewController
        self.navigationController?.pushViewController(favoriteMoviesViewController, animated: true)
    }
}
