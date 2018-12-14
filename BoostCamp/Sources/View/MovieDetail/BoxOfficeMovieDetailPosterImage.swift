//
//  BoxOfficeMovieDetailPosterImage.swift
//  BoostCamp
//
//  Created by Xvezda on 12/11/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import UIKit

class BoxOfficeMovieDetailPosterImage: UIImageView, ImageDownloaderViewProtocol {
  var presenter: ImageDownloaderPresenterProtocol?
  
  var targetWidth: CGFloat!
  private let PADDING: CGFloat = 5.0
  
  init(byWidth width: CGFloat) {
    super.init(image: nil, highlightedImage: nil)
    targetWidth = width
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func showImage(with image: DLImage) {
    DispatchQueue.main.async {
      self.image = UIImage(data: image.data as! Data)?.resizeImage(byWidth: self.targetWidth)
      self.sizeToFit()
      self.bounds = self.frame.insetBy(dx: self.PADDING, dy: self.PADDING)
    }
  }
}
