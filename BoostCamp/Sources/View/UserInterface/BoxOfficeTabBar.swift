//
//  BoxOfficeTabBar.swift
//  BoostCamp
//
//  Created by Xvezda on 12/8/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import UIKit

final class BoxOfficeTabBar: UITabBarController {
  var currentIndex: Int = 0
  var mainViewController: BoxOfficeMovieListView!

  init() {
    super.init(nibName: nil, bundle: nil)
    
    mainViewController = BoxOfficeMovieListView()
    AppDelegate.instance?.rootView = self
    self.viewControllers = [
      self.mainViewController
    ]
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Set tab bar controller
    tabBar.barTintColor = UIColor(rgb: 0x5c6bc0)
    tabBar.tintColor = UIColor(rgb: 0xffffff)
    if #available(iOS 10.0, *) {
      tabBar.unselectedItemTintColor = UIColor.lightGray
    }
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent // .default
  }
}

extension BoxOfficeTabBar: UITabBarControllerDelegate {
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    let index = tabBar.items?.index(of: item) ?? -1
    // Check if index not changed
    if self.currentIndex == index || index == -1 {
      return
    }
    // Change top view controller when tab item
    switch index {
    case 0:
      mainViewController.topChildViewController = mainViewController.childTableViewController
    case 1:
      mainViewController.topChildViewController = mainViewController.childCollectionViewController
    default:
      return
    }
    self.currentIndex = index
    mainViewController.topChildViewController.navigationController?.popViewController(animated: false)
  }
}
