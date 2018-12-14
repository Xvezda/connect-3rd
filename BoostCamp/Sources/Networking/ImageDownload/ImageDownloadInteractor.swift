//
//  ImageDownloaderInteractor.swift
//  BoostCamp
//
//  Created by Xvezda on 12/9/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import Foundation

class ImageDownloaderInteractor: ImageDownloaderInputInteractorProtocol {
  weak var presenter: ImageDownloaderOutputInteractorProtocol?
  var imageCache = ImageStorage()
  
  init(storage: ImageStorage) {
    imageCache = storage
  }

  func getImage(by url: String) {
    if let image = self.imageCache.object(forKey: url as NSString) {
      presenter?.imageDidFetch(image: DLImage(url: url, data: image))
    } else {
      // Download image
      requestImage(url: url, callback: plugImageCache)
    }
  }
  
  func requestImage(url: String, callback: @escaping (DLImage) -> Void) {
    Request.request(
        URL(string: url)!,
        { (data: AnyObject, err: String) -> Void in
      if err.isEmpty {
        self.imageCache.setObject(data, forKey: url as NSString)
        callback(DLImage(url: url, data: data))
      } else {
        callback(DLImage())
      }
    })
  }
  
  func plugImageCache(_ image: DLImage) {
    presenter?.imageDidFetch(image: image)
  }
}
