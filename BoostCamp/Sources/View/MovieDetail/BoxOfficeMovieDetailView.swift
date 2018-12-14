//
//  BoxOfficeMovieDetailView.swift
//  BoostCamp
//
//  Created by Xvezda on 12/9/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import UIKit

final class BoxOfficeMovieDetailView: UIViewController, BoxOfficeMovieDetailViewProtocol {
  var presenter: BoxOfficeMovieDetailPresenterProtocol?
  
  weak var parentView: BoxOfficeMovieListView!

  var scrollView = UIScrollView()
  var stackView = UIStackView()
  var movieDetailView = UIStackView()
  var movieSynopsisView = UITextView()
  var movieCreditView = UITextView()
  var commentView = BoxOfficeMovieCommentTableView()

  var posterImage: BoxOfficeMovieDetailPosterImage?
  var commentList = [Comment]()
  
  init(ref: BoxOfficeMovieListView) {
    super.init(nibName: nil, bundle: nil)
    self.parentView = ref
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Detail view style
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.backgroundColor = UIColor(rgb: 0xdadada)
    let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    scrollView.contentInset = insets
    scrollView.scrollIndicatorInsets = insets
    //scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    movieDetailView.backgroundColor = .white
    movieDetailView.axis = .vertical
    movieDetailView.distribution = .fill
    movieDetailView.alignment = .fill
    
    movieSynopsisView.backgroundColor = .white
    movieSynopsisView.autoresizingMask = UIView.AutoresizingMask(
      rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue |
        UIView.AutoresizingMask.flexibleWidth.rawValue
    )
    
    movieCreditView.backgroundColor = .white
    movieCreditView.autoresizingMask = UIView.AutoresizingMask(
      rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue |
        UIView.AutoresizingMask.flexibleWidth.rawValue
    )
    movieCreditView.isScrollEnabled = false

    // MARK: - Comment View Style
    commentView.register(BoxOfficeMovieCommentTableViewCell.self, forCellReuseIdentifier: "Comment")
    commentView.dataSource = self
    commentView.delegate = self
    // Pseudo-height value for comment table row
    commentView.estimatedRowHeight = 500
    commentView.rowHeight = UITableView.automaticDimension
    commentView.isScrollEnabled = false
    commentView.allowsSelection = false
    commentView.backgroundColor = .white
    commentView.separatorStyle = .none
    commentView.translatesAutoresizingMaskIntoConstraints = false
    commentView.autoresizingMask = UIView.AutoresizingMask(
      rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue |
        UIView.AutoresizingMask.flexibleWidth.rawValue
    )

    // MARK: - Comment Table Header
    let commentHeader = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    commentHeader.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
    commentHeader.font = UIFont.systemFont(ofSize: 18)
    commentHeader.text = "one_line_comment".localized
    commentHeader.isEditable = false
    commentHeader.isSelectable = false
    commentHeader.isScrollEnabled = false
    commentView.tableHeaderView = commentHeader

    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    stackView.alignment = .fill
    stackView.spacing = 10
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.autoresizingMask = UIView.AutoresizingMask(
      rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue |
        UIView.AutoresizingMask.flexibleWidth.rawValue
    )
    stackView.addArrangedSubview(movieDetailView)
    stackView.addArrangedSubview(movieSynopsisView)
    stackView.addArrangedSubview(movieCreditView)
    stackView.addArrangedSubview(commentView)

    scrollView.addSubview(stackView)
    scrollView.frame = self.view.bounds
    self.view.addSubview(scrollView)
    
    // make stack view items width to scroll view width
    movieDetailView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    movieSynopsisView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    movieCreditView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    commentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    //commentListView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

    let backButton = UIBarButtonItem()
    backButton.title = "movie_list".localized
    self.navigationController?.navigationBar
        .topItem?.backBarButtonItem = backButton

    presenter?.viewDidLoad()
   }
  
  // MARK: - Movie Detail
  func showMovieDetail(with movie: Movie) {
    self.title = movie.title
    

    // Set movie detail view header
    let boldFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
    let movieDetailHeader = UIStackView()
    movieDetailHeader.backgroundColor = .white
    movieDetailHeader.axis = .horizontal
    movieDetailHeader.distribution = .fill
    movieDetailHeader.alignment = .leading

    // Set poster size 1/3 of width
    let targetWidth = scrollView.bounds.width / 3
    let posterPlaceHolder = UIView(frame: CGRect(x: 0, y: 0, width: targetWidth, height: 150))
    posterPlaceHolder.backgroundColor = .white

    posterImage = BoxOfficeMovieDetailPosterImage(byWidth: targetWidth)
    posterImage!.clipsToBounds = true
    ImageDownloaderWireframe.createImageDownloaderModule(ref: posterImage!, storage: parentView.imageStorage)
    posterImage!.presenter?.downloadImage(by: movie.image!)
    posterPlaceHolder.addSubview(posterImage!)
    movieDetailHeader.addArrangedSubview(posterPlaceHolder)
    posterPlaceHolder.heightAnchor.constraint(equalTo: movieDetailHeader.heightAnchor).isActive = true
    
    // Set poster click to fullsize
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actPosterFullSize))
    posterImage!.isUserInteractionEnabled = true
    posterImage!.addGestureRecognizer(tapGestureRecognizer)
    
    // MARK: - Movie Title
    let movieTitleView = UIStackView()
    movieTitleView.backgroundColor = .white
    movieTitleView.axis = .vertical
    movieTitleView.distribution = .fill
    movieTitleView.alignment = .bottom
    
    // Dummy padding view to make title text vertical aligned
    let movieTitlePadding = UIView()
    movieTitlePadding.backgroundColor = .white
    movieTitleView.addArrangedSubview(movieTitlePadding)

    let movieTitleText = UITextView()
    let movieTitleAttrText = NSMutableAttributedString(string: movie.title+" ", attributes: [
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21)
    ])
    let gradeIconImg = UIImage(
      named: "grade_\((movie.grade == 0 ? "all" : String(movie.grade))).png"
    )
    let gradeIcon = NSTextAttachment()
    gradeIcon.bounds = CGRect(x: 5, y: -5, width: 28, height: 28)
    gradeIcon.image = gradeIconImg
    let gradeIconString = NSAttributedString(attachment: gradeIcon)
    movieTitleAttrText.append(gradeIconString)
    movieTitleText.attributedText = movieTitleAttrText
    movieTitleText.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10)
    movieTitleText.isEditable = false
    movieTitleText.isSelectable = false
    movieTitleText.isScrollEnabled = false

    let movieTitleDetailText = UITextView()
    let movieTitleDetailStyle = NSMutableParagraphStyle()
    movieTitleDetailStyle.lineSpacing = 10
    let movieTitleDetailAttributes = [
      NSAttributedString.Key.paragraphStyle: movieTitleDetailStyle,
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
    ]
    movieTitleDetailText.attributedText = NSAttributedString(string: String(format:
      "movie_detail_info_fmt".localized, movie.date, movie.genre!, movie.duration!
    ), attributes: movieTitleDetailAttributes)
    movieTitleDetailText.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10)
    movieTitleDetailText.isEditable = false
    movieTitleDetailText.isSelectable = false
    movieTitleDetailText.isScrollEnabled = false
    
    // Add title and detail text to title view
    movieTitleView.addArrangedSubview(movieTitleText)
    movieTitleView.addArrangedSubview(movieTitleDetailText)
    
    // Set width of subviews in title view
    movieTitlePadding.widthAnchor.constraint(equalToConstant: scrollView.bounds.width - targetWidth).isActive = true
    movieTitleText.widthAnchor.constraint(equalToConstant: scrollView.bounds.width - targetWidth).isActive = true
    movieTitleDetailText.widthAnchor.constraint(equalToConstant: scrollView.bounds.width - targetWidth).isActive = true

    // Add title view to detail header
    movieDetailHeader.addArrangedSubview(movieTitleView)
    movieTitleView.heightAnchor.constraint(equalTo: movieDetailHeader.heightAnchor).isActive = true

    // Set movie detail view body
    let movieDetailBody = UIStackView()
    
    movieDetailBody.backgroundColor = .white
    movieDetailBody.axis = .horizontal
    movieDetailBody.distribution = .fillEqually
    movieDetailBody.alignment = .center
    
    // Add header and body to movie detail view
    movieDetailView.addArrangedSubview(movieDetailHeader)
    movieDetailView.addArrangedSubview(movieDetailBody)
    movieDetailView.heightAnchor.constraint(equalTo: movieDetailView.widthAnchor, multiplier: 0.66).isActive = true

    // MARK: - Movie Detail Reservation Rate
    let movieReservationRate = UITextView()
    let movieReservationTitle = "movie_reservation_rate".localized
    let movieReservationBody = String(
      format: "movie_detail_reservation_rate_fmt".localized,
      movie.reservationGrade,
      movie.reservationRate
    )
    let movieReservationText = NSMutableAttributedString(string: movieReservationTitle + "\n\n" + movieReservationBody)
    movieReservationText.addAttributes(boldFont, range: NSRange(location: 0, length: movieReservationTitle.count))
    movieReservationRate.attributedText = movieReservationText
    movieReservationRate.textAlignment = .center
    movieReservationRate.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    movieReservationRate.isEditable = false
    movieReservationRate.isSelectable = false
    movieReservationRate.isScrollEnabled = false
    movieReservationRate.sizeToFit()
    
    movieDetailBody.addArrangedSubview(movieReservationRate)
    movieReservationRate.heightAnchor.constraint(equalTo: movieDetailBody.heightAnchor).isActive = true

    // MARK: - Movie Detail User Rate
    let movieUserRating = UITextView()
    let movieUserRatingTitle = "movie_user_rating".localized
    let movieUserRatingBody = String(movie.userRating)
    let movieUserRatingText = NSMutableAttributedString(string: movieUserRatingTitle + "\n" + movieUserRatingBody + "\n")
    movieUserRatingText.addAttributes(boldFont, range: NSRange(location: 0, length: movieUserRatingTitle.count))
    movieUserRating.attributedText = movieUserRatingText
    let rateIcon = UIImage(named: "rate_mask")?.resizeImage(byRatio: 0.75)
    let rateMask = UIImageView(image: rateIcon)
    let rateBar = UIView(frame:
      CGRect(x: 0, y: 0,
        width: (rateMask.bounds.width-1) * CGFloat(movie.userRating!*10 / 100),
       height: rateMask.bounds.height - 1)
    )
    rateBar.backgroundColor = UIColor(rgb: 0xfd961d)
    movieUserRating.sizeToFit()
    let rateBase = UIView(
      frame: CGRect(
        x: movieUserRating.bounds.width / 2,
        y: movieUserRating.bounds.height - rateMask.bounds.height,
        width: rateMask.bounds.width,
        height: rateMask.bounds.height
      )
    )
    rateBase.backgroundColor = UIColor(rgb: 0xeaeaea)
    rateBase.addSubview(rateBar)
    rateMask.image = rateIcon
    rateBase.addSubview(rateMask)
    movieUserRating.addSubview(rateBase)
    
    movieUserRating.textAlignment = .center
    movieUserRating.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    movieUserRating.isEditable = false
    movieUserRating.isSelectable = false
    movieUserRating.isScrollEnabled = false
    movieUserRating.sizeToFit()

    movieDetailBody.addArrangedSubview(movieUserRating)
    movieUserRating.heightAnchor.constraint(equalTo: movieDetailBody.heightAnchor).isActive = true
    
    let leftSeparater = CALayer()
    leftSeparater.borderWidth = 1
    leftSeparater.borderColor = UIColor.lightGray.cgColor
    leftSeparater.frame = CGRect(x: 0, y: 5, width: 1, height: 50)
    movieUserRating.layer.addSublayer(leftSeparater)
    

    // MARK: - Movie Detail Audience
    let movieAudience = UITextView()
    let movieAudienceTitle = "movie_audience".localized
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let movieAudienceBody = numberFormatter.string(from: NSNumber(value: movie.audience!))
    let movieAudienceText = NSMutableAttributedString(string: movieAudienceTitle + "\n\n" + movieAudienceBody!)
    movieAudienceText.addAttributes(boldFont, range: NSRange(location: 0, length: movieAudienceTitle.count))
    
    movieAudience.attributedText = movieAudienceText
    movieAudience.textAlignment = .center
    movieAudience.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    movieAudience.isEditable = false
    movieAudience.isSelectable = false
    movieAudience.isScrollEnabled = false
    movieAudience.sizeToFit()
    
    movieDetailBody.addArrangedSubview(movieAudience)
    movieAudience.heightAnchor.constraint(equalTo: movieDetailBody.heightAnchor).isActive = true
    
    let rightSeparater = CALayer()
    rightSeparater.borderWidth = 1
    rightSeparater.borderColor = UIColor.lightGray.cgColor
    rightSeparater.frame = CGRect(x: 0, y: 5, width: 1, height: 50)
    movieAudience.layer.addSublayer(rightSeparater)

    // MARK - Movie Detail Synopsis
    let synopsisHeader = UITextView()
    synopsisHeader.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    synopsisHeader.font = UIFont.systemFont(ofSize: 18)
    synopsisHeader.text = "movie_synopsis".localized
    synopsisHeader.isEditable = false
    synopsisHeader.isSelectable = false
    synopsisHeader.isScrollEnabled = false
    synopsisHeader.sizeToFit()
    movieSynopsisView.addSubview(synopsisHeader)
    
    movieSynopsisView.font = UIFont.systemFont(ofSize: 16)
    movieSynopsisView.text = movie.synopsis
    // Give padding to synopsis view
    movieSynopsisView.textContainerInset = UIEdgeInsets(top: 50, left: 10, bottom: 10, right: 10)
    // Make view read-only
    movieSynopsisView.isEditable = false
    movieSynopsisView.isSelectable = false
    movieSynopsisView.isScrollEnabled = false
    movieSynopsisView.sizeToFit()
    
    // MARK: - Movie Deatil Staff Credit
    let creditHeader = UITextView()
    creditHeader.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    creditHeader.font = UIFont.systemFont(ofSize: 18)
    creditHeader.text = "movie_credit".localized
    creditHeader.isEditable = false
    creditHeader.isSelectable = false
    creditHeader.isScrollEnabled = false
    creditHeader.sizeToFit()
    movieCreditView.addSubview(creditHeader)
    
    let credit = NSString(
      string: "director".localized + " " + movie.director! + "\n" +
              "actor".localized    + " " + movie.actor!
    )
    let attributedCredit = NSMutableAttributedString(
      string: credit as String,
      attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
    )
    attributedCredit.addAttributes(boldFont, range: credit.range(of: "director".localized))
    attributedCredit.addAttributes(boldFont, range: credit.range(of: "actor".localized))
    movieCreditView.attributedText = attributedCredit
    movieCreditView.textContainerInset = UIEdgeInsets(top: 50, left: 10, bottom: 10, right: 10)
    movieCreditView.isEditable = false
    movieCreditView.isSelectable = false
    movieCreditView.isScrollEnabled = false
    movieCreditView.sizeToFit()

    presenter?.loadCommentList()
  }
  
  // MARK: - Load Comment
  func showCommentList(with comments: [Comment]) {
    self.commentList = comments
    DispatchQueue.main.async {
      self.commentView.reloadData()
      self.commentView.layoutIfNeeded()
      self.stackView.layoutIfNeeded()
      self.stackView.sizeToFit()
      self.commentView.heightAnchor.constraint(equalToConstant: self.commentView.contentSize.height).isActive = true
      self.scrollView.contentSize = self.stackView.bounds.size
      
      // MARK: - Add comment button
      let addCommentButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
      addCommentButton.tintColor = .red
      addCommentButton.setImage(UIImage(named: "baseline_add_comment_black_24pt"), for: UIButton.State.normal)
      self.commentView.addSubview(addCommentButton)
      addCommentButton.center = CGPoint(
        x: self.commentView.bounds.width - addCommentButton.bounds.width,
        y: addCommentButton.bounds.height
      )
    }
  }
  
  // MARK: - Poster Action
  @objc func actPosterFullSize(_ sender: UITapGestureRecognizer) {
    // Hide navigation bar and tab bar
    self.navigationController?.isNavigationBarHidden = true
    self.tabBarController?.tabBar.isHidden = true
    
    // Load full size poster
    presenter?.loadFullSizeMoviePoster()
  }
  
  func showFullSizeMoviePoster(with movie: Movie) {
    // Get image from image storage
    let fullSizeImage = UIImage(data: parentView.imageStorage.object(forKey: movie.image! as NSString) as! Data)
    // Make view by full size image
    let fullScreenImageView = UIImageView(image: fullSizeImage)
    fullScreenImageView.frame = UIScreen.main.bounds
    fullScreenImageView.contentMode = .scaleAspectFit  // Keep poster image size ratio
    fullScreenImageView.backgroundColor = .black
    fullScreenImageView.isUserInteractionEnabled = true
    
    // Add gesture to image viewer
    let tapGestureRecognizer = UITapGestureRecognizer()
    tapGestureRecognizer.addTarget(self, action: #selector(closeFullSizeMoviePoster))
    fullScreenImageView.isUserInteractionEnabled = true
    fullScreenImageView.addGestureRecognizer(tapGestureRecognizer)

    self.view.addSubview(fullScreenImageView)
  }
  
  @objc func closeFullSizeMoviePoster(_ sender: UITapGestureRecognizer) {
    // Show navigation bar and tab bar
    self.navigationController?.isNavigationBarHidden = false
    self.tabBarController?.tabBar.isHidden = false
    // Remove from super view
    sender.view?.removeFromSuperview()
  }
  
  // MARK: - Native
  func showAlert(message: String) {
    parentView?.showAlert(message: message)
  }
  
  func showIndicator() {
    parentView?.showIndicator()
  }
  
  func hideIndicator() {
    parentView?.hideIndicator()
  }
}

// MARK: - Comment DataSource / Delegate
extension BoxOfficeMovieDetailView: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 20.0
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return commentList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = BoxOfficeMovieCommentTableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Comment")
    let comment = commentList[indexPath.row]

    cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
    cell.textLabel?.lineBreakMode = .byTruncatingTail
    var writer = comment.writer!
    if writer.count > 14 {
      writer = writer[writer.startIndex...writer.index(writer.startIndex, offsetBy: 14)] + "..."
    }
    cell.textLabel?.text = writer

    // Set comment rate icon
    let rateIcon = UIImage(named: "rate_mask")?.resizeImage(byRatio: 0.75)
    let rateMask = UIImageView(image: rateIcon)
    let rateBar = UIView(frame:
      CGRect(x: 0, y: 0,
        width: (rateMask.bounds.width-1) * CGFloat(comment.rating!*10 / 100),
        height: rateMask.bounds.height-1)
    )
    rateBar.backgroundColor = UIColor(rgb: 0xfd961d)
    let rateBase = UIView(frame: CGRect(
      x: 0, y: 0,
      width: rateMask.bounds.width, height: rateMask.bounds.height)
    )
    rateBase.backgroundColor = UIColor(rgb: 0xeaeaea)
    rateBase.addSubview(rateBar)
    rateMask.image = rateIcon
    rateBase.addSubview(rateMask)
    cell.textLabel?.sizeToFit()
    let rateView = UIView(frame:
      CGRect(x: cell.textLabel!.bounds.width + 5,
             y: 0.0,
             width: rateBase.bounds.width,
             height: rateBase.bounds.height
      )
    )
    rateView.addSubview(rateBase)
    cell.textLabel?.addSubview(rateView)
    
    cell.detailTextLabel?.numberOfLines = 0
    cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
    // Translate comment unix timestamp to date format
    let date = Date(timeIntervalSince1970: comment.timestamp)
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let dateString = dateFormatter.string(from: date)
    let contentText = dateString + "\n\n" + comment.contents + "\n"
    let dateRange = (contentText as NSString).range(of: dateString)
    let attributedContentText = NSMutableAttributedString(string: contentText)
    attributedContentText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: dateRange)
    attributedContentText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: dateRange)

    cell.detailTextLabel?.attributedText = attributedContentText

    // Set user's profile image
    let profileImg = UIImage(named: "baseline_account_circle_black_48pt")
    cell.imageView?.contentMode = .topLeft
    cell.imageView?.tintColor = UIColor.lightGray
    cell.imageView?.image = profileImg

    return cell
  }
}
