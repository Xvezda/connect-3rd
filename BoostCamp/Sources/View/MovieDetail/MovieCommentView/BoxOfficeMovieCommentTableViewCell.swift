//
//  BoxOfficeMovieCommentTableViewCell.swift
//  BoostCamp
//
//  Created by Xvezda on 12/12/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import UIKit

class BoxOfficeMovieCommentTableViewCell: UITableViewCell {
  override func layoutSubviews() {
    super.layoutSubviews()
    //let originalTitleView = self.textLabel
    //let originalContentView = self.detailTextLabel
    let originalImageView = self.imageView
    self.imageView?.frame = CGRect(
      x: originalImageView!.bounds.size.width / 2 - 7,
      y: 12,
      width: 0,
      height: 0)
  }
}
