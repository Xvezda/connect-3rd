//
//  BoxOfficeNavigationBar.swift
//  BoostCamp
//
//  Created by Xvezda on 12/9/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import UIKit

class BoxOfficeNavigationBar: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationBar.barTintColor = UIColor(rgb: 0x5c6bc0)
    self.navigationBar.tintColor = UIColor.white
    self.navigationBar.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
  }
}
