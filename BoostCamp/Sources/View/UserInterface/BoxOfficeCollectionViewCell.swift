//
//  BoxOfficeCollectionViewCell.swift
//  BoostCamp
//
//  Created by Xvezda on 12/10/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import UIKit

class BoxOfficeCollectionViewCell: UICollectionViewCell, ImageDownloaderViewProtocol {
  var presenter: ImageDownloaderPresenterProtocol?
  
  func showImage(with image: DLImage) {
    DispatchQueue.main.async {
      let imageView = UIImageView(
        frame: CGRect(
          x: 0.0, y: 0.0,
          width: self.bounds.width,
          // Height should become 2/3 of container for text label space
          height: self.bounds.height * 0.75)
      )
      if let data = image.data as? Data {
        imageView.image = UIImage(data: data)
      }
      self.contentView.insertSubview(imageView, at: 0)
      self.setNeedsLayout()
    }
  }
}

