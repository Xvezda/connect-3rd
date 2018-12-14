//
//  BoxOfficeMovieCommentTableView.swift
//  BoostCamp
//
//  Created by Xvezda on 12/12/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import UIKit

class BoxOfficeMovieCommentTableView: UITableView {
  override var contentSize: CGSize {
    didSet {
      // Dynamically set height of comment table
      self.invalidateIntrinsicContentSize()
    }
  }
  
  override var intrinsicContentSize: CGSize {
    self.layoutIfNeeded()
    return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
  }
}
