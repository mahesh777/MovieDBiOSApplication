//
//  FavoriteMoviesViewController.swift
//  MovieDBApplication
//
//  Created by Mahesh Sonaiya on 26/08/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class FavoriteMoviesViewController: UIViewController {
    
    // MARK: - IBOutlet properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - fileprivate properties
    fileprivate var movieInfoList: [MovieDetailInfo]? = []
    
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
        if size.width > 768 { return 4 }
        else if size.width > 414 { return 3 }
        else { return 2 }
    }
    
    // MARK: - View Model
    fileprivate let favoriteMovieViewModel = FavoriteMovieViewModel()
    fileprivate var isDataLoading = false
    
    // MARK: - UIViewController handling
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Favorited Movies"
        setupUI()
        getDataFromLocalDB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionViewItemsPerRow = self.itemsPerRow(for: UIScreen.main.bounds.size)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getDataFromLocalDB()
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Setup
    fileprivate func setupUI() {
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        self.collectionView.register(UINib.init(nibName: "MovieListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    // MARK: - Get Data From Local DB
    fileprivate func getDataFromLocalDB() {
        movieInfoList = favoriteMovieViewModel.getListOfFavoriteMovies()
        self.collectionView.reloadData()
    }
}

extension FavoriteMoviesViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDataSource and UICollectionViewDelegate Methods
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath) as! MovieListCollectionViewCell
        // Configure the cell
        let movie = movieInfoList![indexPath.row]
        cell.populate(withPosterPath: movie.posterPath)
        cell.setFavoriteUI(movieId: movie.movieId)
        
        cell.movieFavoriteButton.tag = indexPath.row
        cell.movieFavoriteButton .addTarget(self, action: #selector(self.favoriteMovieClickEvent(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let moveilist = movieInfoList {
            return moveilist.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movieInfoList![indexPath.row]
        goToDetailView(movieInfo: movie)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewItemWidth, height: self.collectionViewItemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.collectionViewMargin, left: self.collectionViewMargin, bottom: self.collectionViewMargin, right: self.collectionViewMargin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.collectionViewMargin
    }
    
    // MARK:- Favorite Movie Click Event
    @objc func favoriteMovieClickEvent(_ sender : UIButton) {
        let rowIndex = sender.tag
        let movieInfo = self.movieInfoList![rowIndex]
        favoriteMovieViewModel.markAsFavoriteDetailView(isFavorite: false, movieDetailInfo: movieInfo)
        movieInfoList?.removeAll()
        getDataFromLocalDB()
    }
    
    // MARK:- Go To Detail View
    func goToDetailView(movieInfo : MovieDetailInfo?) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = storyBoard.instantiateViewController(withIdentifier: "idMovieDetailVC") as! MovieDetailViewController
        let viewModel = MovieDetailViewModel.init()
        viewModel.movieId = movieInfo?.movieId
        viewModel.moviePosterPath = movieInfo?.posterPath
        viewModel.movieDetailInfo = movieInfo
        detailsViewController.setUpViewModel(viewModel: viewModel)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
