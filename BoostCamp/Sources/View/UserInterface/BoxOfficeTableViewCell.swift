//
//  BoxOfficeTableViewCell.swift
//  BoostCamp
//
//  Created by Xvezda on 12/10/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import UIKit

class BoxOfficeTableViewCell: UITableViewCell, ImageDownloaderViewProtocol {
  var presenter: ImageDownloaderPresenterProtocol?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func showImage(with image: DLImage) {
    DispatchQueue.main.async {
      if let data = image.data as? Data {
        self.imageView?.image = UIImage(data: data)
      } else {
        self.imageView?.image = nil
      }
      self.setNeedsLayout()
    }
  }
}

