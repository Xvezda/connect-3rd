//
//  BoxOfficeMovieListView.swift
//  BoostCamp
//
//  Created by Xvezda on 12/8/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import UIKit

final class BoxOfficeMovieListView: UIViewController, BoxOfficeViewProtocol {
  // MARK: - Native Controllers
  var alertController: UIAlertController?
  let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  
  var generateRefreshControl: () ->
        () -> (UIRefreshControl) = {
    return {
      let refreshControl = UIRefreshControl()
      refreshControl.addTarget(self, action: #selector(BoxOfficeMovieListView.refresh), for: UIControl.Event.valueChanged)
      return refreshControl
    }
  }
  lazy var refreshTableControl: UIRefreshControl = (generateRefreshControl())()
  lazy var refreshCollectionControl: UIRefreshControl = (generateRefreshControl())()

  @objc func refresh(sender: AnyObject) {
    DispatchQueue.main.async {
      if !self.childTableView.isDragging ||
         !self.childCollectionView.isDragging {
        self.presenter?.loadMovieList(by: self.sortMethod)
      }
    }
  }
  
  // MARK: - Properties
  var presenter: BoxOfficePresenterProtocol?
  var movieList = [Movie]()
  var imageStorage = ImageStorage()
  var sortSettingButton: UIBarButtonItem?

  var sortMethod: SortMethod! {
    willSet {
      setNavigationTitle(newValue.rawValue.localized)
      presenter?.loadMovieList(by: newValue)
    }
  }
  
  // Views for displaying movie list
  var childTableView: UITableView!
  var childTableViewController: UITableViewController!
  var childCollectionView: UICollectionView!
  var childCollectionViewController: UICollectionViewController!
  var topChildViewController: UIViewController!
  
  // Collection view cell reuse id
  let collectionCellId = "Cell"
  
  var movieDetail: BoxOfficeMovieDetailView?

  // MARK: - Layout
  override func viewDidLoad() {
    super.viewDidLoad()

    // MARK: - Child Table View Settings
    childTableView = UITableView()
    childTableView.delegate = self
    childTableView.dataSource = self
    childTableView.frame = self.view.bounds
    childTableView.rowHeight = 150.0
    childTableView.tag = 0
    
    // MARK: - Child Collection View Settings
    let layout = UICollectionViewFlowLayout()
    let margin: CGFloat = 10.0
    layout.sectionInset = UIEdgeInsets(
      top: margin,
      left: margin,
      bottom: margin,
      right: margin
    )
    var halfWidth: CGFloat = 0.0
    // Use shorter side
    if self.view.bounds.size.width > self.view.bounds.size.height {
      halfWidth = self.view.bounds.size.height / 2.0 - margin * 2.0
    } else {
      halfWidth = self.view.bounds.size.width / 2.0 - margin * 2.0
    }
    layout.itemSize = CGSize(width: halfWidth, height: halfWidth*2.0)

    childCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    childCollectionView.backgroundColor = .white
    
    childCollectionView.delegate = self
    childCollectionView.dataSource = self
    childCollectionView.frame = self.view.bounds
    childCollectionView.register(
      BoxOfficeCollectionViewCell.self,
      forCellWithReuseIdentifier: "Cell"
    )
    childCollectionView.tag = 1
    
    // MARK: - Child Table View Controller
    childTableViewController = BoxOfficeTableViewController()
    childTableViewController.tableView = childTableView
    childTableViewController.tabBarItem = UITabBarItem(
      title: "Table",
      image: UIImage(named: "baseline_view_list_white_36pt"),
      tag: 0
    )
    // MARK: - Child Collection View Controller
    childCollectionViewController = BoxOfficeCollectionViewController()
    childCollectionViewController.collectionView = childCollectionView
    childCollectionViewController.tabBarItem = UITabBarItem(
      title: "Collection",
      image: UIImage(named: "baseline_view_module_white_36pt"),
      tag: 1
    )
    childTableViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(named: "baseline_settings_white_24pt"),
      style: .plain,
      target: self,
      action: #selector(self.showSortMethodMenu)
    )
    childCollectionViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(named: "baseline_settings_white_24pt"),
      style: .plain,
      target: self,
      action: #selector(self.showSortMethodMenu)
    )
    // MARK: - Pull To Refresh
    // Add pull to refresh feature to child views
    childTableViewController.refreshControl = self.refreshTableControl
    childTableViewController.extendedLayoutIncludesOpaqueBars = true
    childCollectionView.addSubview(self.refreshCollectionControl)
    childCollectionViewController.extendedLayoutIncludesOpaqueBars = true

    // MARK: - Tab Bar Settings
    self.tabBarController?.viewControllers = [
      BoxOfficeNavigationBar(rootViewController: childTableViewController),
      BoxOfficeNavigationBar(rootViewController: childCollectionViewController)
    ]
    self.sortMethod = SortMethod.AdvanceRate
    topChildViewController = childTableViewController

    // Load movie list when view is loaded
    BoxOfficeWireframe.createMovieList(ref: self)
    presenter?.viewDidLoad()
  }

  func setNavigationTitle(_ string: String) {
    childTableViewController.navigationItem.title = string
    childCollectionViewController.navigationItem.title = string
  }

  func showMovieList(with movies: [Movie]) {
    DispatchQueue.main.async {
      self.movieList = movies
      self.refreshTableControl.perform(
        #selector(self.refreshTableControl.endRefreshing),
        with: nil, afterDelay: 0.05
      )
      self.refreshCollectionControl.perform(
        #selector(self.refreshCollectionControl.endRefreshing),
        with: nil, afterDelay: 0.05
      )
      // Add some delay to provide smooth animation
      DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
        self.childTableView.reloadData()
        self.childCollectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25, execute: {
          self.hideIndicator()
        })
      })
    }
  }

  // MARK: - Buttons & Actions
  func showAlert(message: String) {
    DispatchQueue.main.async {
      self.alertController = UIAlertController(
        title: "Error",
        message: message,
        preferredStyle: .alert
      )
      let defaultAction = UIAlertAction(
        title: "OK",
        style: UIAlertAction.Style.destructive, handler : nil
      )
      self.alertController?.addAction(defaultAction)
      AppDelegate.instance?.rootView?
          .present(self.alertController!, animated: true, completion: nil)
    }
  }
  
  @objc func showSortMethodMenu() {
    alertController = UIAlertController(
      title: "sort_method_title".localized,
      message: "sort_method_desc".localized,
      preferredStyle: .actionSheet)
    
    alertController?.addAction(
      UIAlertAction(title: "advance_rate".localized,
                    style: .default,
                    handler: {(UIAlertAction) -> Void in
                      self.sortMethod = .AdvanceRate
      })
    )
    alertController?.addAction(
      UIAlertAction(title: "curation".localized,
                    style: .default,
                    handler: {(UIAlertAction) -> Void in
                      self.sortMethod = .Curation
      })
    )
    alertController?.addAction(
      UIAlertAction(title: "release_date".localized,
                    style: .default,
                    handler:  {(UIAlertAction) -> Void in
                      self.sortMethod = .ReleaseDate
      })
    )
    alertController?.addAction(
      UIAlertAction(title: "cancel".localized,
                    style: .cancel,
                    handler: nil)
    )
    AppDelegate.instance?.rootView?.present(alertController!, animated: true, completion: nil)
  }

  // MARK: - Indicator
  func showIndicator() {
    if self.activityIndicator.isHidden {
      // Set 5 seconds timeout timer.
      DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: {
        if self.movieList.count <= 0 {
          self.showAlert(message: "unknown_error".localized)
          self.hideIndicator()
        }
      })
      // Set network indicator styles
      self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
      //self.activityIndicator.center = self.view.center
      self.activityIndicator.center = CGPoint(
        x: (AppDelegate.instance?.rootView?.view.bounds.size.width ??
          self.view.bounds.size.width) / 2.0,
        y: (AppDelegate.instance?.rootView?.view.bounds.size.height ??
          self.view.bounds.size.height) / 2.0
      )
      self.activityIndicator.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
      self.activityIndicator.layer.cornerRadius = 5;
      self.activityIndicator.hidesWhenStopped = true;
      self.activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge;
      AppDelegate.instance?.rootView?.view.addSubview(self.activityIndicator)
      
      self.activityIndicator.startAnimating()
      UIApplication.shared.beginIgnoringInteractionEvents()
      // Set status bar network indicator enabled
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
  }
  
  func hideIndicator() {
    DispatchQueue.main.async {
      if !self.activityIndicator.isHidden {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        // Set status bar network indicator disabled
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
    }
  }
  
  func pushMovieDetail(of movie: Movie) {
    DispatchQueue.main.async {
      self.hideIndicator()
      self.movieDetail = BoxOfficeMovieDetailView(ref: self)
      BoxOfficeMovieDetailWireframe.createMovieDetailModule(ref: self.movieDetail!, with: movie)
      self.topChildViewController.navigationController?.pushViewController(self.movieDetail!, animated: true)
    }
  }
}

// MARK: - Scroll View Delegate
extension BoxOfficeMovieListView: UIScrollViewDelegate {
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if self.refreshTableControl.isRefreshing == true ||
      self.refreshCollectionControl.isRefreshing == true {
      self.presenter?.loadMovieList(by: self.sortMethod)
    }
  }
}

// MARK: - Child Table View Datasource / Delegate
extension BoxOfficeMovieListView: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter?.loadMovieDetail(of: movieList[indexPath.row])
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movieList.count
  }
  
  // MARK: - Table Cell
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Create table cell
    let movie = movieList[indexPath.row]
    let cell = BoxOfficeTableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: collectionCellId)

    // Set title text
    cell.textLabel?.font = UIFont.systemFont(ofSize: 24)
    
    let titleAttrText = NSMutableAttributedString(string: movie.title)
    let titleParagraphStyle = NSMutableParagraphStyle()
    titleParagraphStyle.lineSpacing = 16
    titleParagraphStyle.lineBreakMode = .byTruncatingMiddle
    titleAttrText.addAttribute(
      NSAttributedString.Key.paragraphStyle,
      value: titleParagraphStyle,
      range: NSMakeRange(0, movie.title.count)
    )
    // Add grade icon to title
    let gradeIconImg = UIImage(
      named: "grade_\((movie.grade == 0 ? "all" : String(movie.grade))).png"
      )
    let gradeIcon = NSTextAttachment()
    gradeIcon.bounds = CGRect(x: 10, y: -5, width: 28, height: 28)
    gradeIcon.image = gradeIconImg
    let gradeIconString = NSAttributedString(attachment: gradeIcon)
    titleAttrText.append(gradeIconString)
    cell.textLabel?.attributedText = titleAttrText

    // Set description text
    cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
    cell.detailTextLabel?.numberOfLines = 2
    
    let descText = String(
      format: "movie_list_info_table_view_fmt".localized,
      movie.userRating, movie.reservationGrade, movie.reservationRate,
      movie.date
    )
    let descAttrText = NSMutableAttributedString(string: descText)
    let descParagraphStyle = NSMutableParagraphStyle()
    descParagraphStyle.lineSpacing = 16
    descAttrText.addAttribute(
      NSAttributedString.Key.paragraphStyle,
      value: descParagraphStyle,
      range: NSMakeRange(0, descText.count)
    )
    cell.detailTextLabel?.attributedText = descAttrText
    
    // Load thumbnail image from donwloader module
    ImageDownloaderWireframe
        .createImageDownloaderModule(ref: cell, storage: self.imageStorage)
    cell.presenter?.downloadImage(by: movie.thumb!)

    return cell
  }
}

// MARK: - Child Collection View Datasource / Delegate / Layout
extension BoxOfficeMovieListView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    presenter?.loadMovieDetail(of: movieList[indexPath.row])
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movieList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let movie = movieList[indexPath.row]
    let cell = collectionView
        .dequeueReusableCell(
            withReuseIdentifier: collectionCellId,
            for: indexPath as IndexPath
        ) as! BoxOfficeCollectionViewCell
    // Clear subviews
    cell.contentView.subviews.forEach({ $0.removeFromSuperview() })

    // Load thumbnails
    ImageDownloaderWireframe.createImageDownloaderModule(ref: cell, storage: self.imageStorage)
    cell.presenter?.downloadImage(by: movie.thumb!)
    
    // Add grade mark to poster
    let gradeIconImg = UIImage(
      named: "grade_\((movie.grade == 0 ? "all" : String(movie.grade))).png"
     )
    let gradeIconView = UIImageView(
      frame: CGRect(
        x: cell.bounds.size.width - 35, y: 7,
        width: 28, height: 28)
    )
    gradeIconView.image = gradeIconImg
    cell.contentView.insertSubview(gradeIconView, at: 1)

    // Set title text view
    let titleLabel = UILabel(frame:
      CGRect(
        x: 0, y: cell.bounds.size.height * 0.75,
        width: cell.bounds.size.width, height: 50
      )
    )
    titleLabel.font = UIFont.systemFont(ofSize: 21)
    titleLabel.text = movie.title
    titleLabel.textAlignment = .center
    cell.contentView.addSubview(titleLabel)
    
    // Set desc text view
    let descLabel = UILabel(frame:
      CGRect(
        x: 0, y: cell.bounds.size.height * 0.85,
        width: cell.bounds.size.width, height: 50
      )
    )
    descLabel.font = UIFont.systemFont(ofSize: 16)
    descLabel.text = String(format:
      "movie_list_info_collection_view_fmt".localized,
      movie.reservationGrade, movie.userRating, movie.reservationRate,
      movie.date
    )
    descLabel.textAlignment = .center
    descLabel.numberOfLines = 2
    cell.contentView.addSubview(descLabel)
    
    return cell
  }
}

