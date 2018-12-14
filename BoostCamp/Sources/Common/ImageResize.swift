//
//  ImageResize.swift
//  BoostCamp
//
//  Created by Xvezda on 12/13/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import UIKit

extension UIImage {
  func resizeImage(bySize: CGSize) -> UIImage {
    let targetSize = bySize
    
    UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
    self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: targetSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
  
  func resizeImage(byWidth width: CGFloat) -> UIImage {
    let originalWidth = self.size.width
    let originalHeight = self.size.height
    let targetHeight = originalHeight / (originalWidth / width)
    let targetSize = CGSize(width: width, height: targetHeight)
    
    UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
    self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: targetSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
  }
  
  func resizeImage(byHeight height: CGFloat) -> UIImage {
    let originalWidth = self.size.width
    let originalHeight = self.size.height
    let targetWidth = originalWidth / (originalHeight / height)
    let targetSize = CGSize(width: targetWidth, height: height)
    
    UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
    self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: targetSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
  
  func resizeImage(byRatio ratio: CGFloat) -> UIImage {
    let originalWidth = self.size.width
    let originalHeight = self.size.height
    let targetSize = CGSize(
      width: originalWidth * ratio,
      height: originalHeight * ratio
    )
    
    UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
    self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: targetSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
  }
}
