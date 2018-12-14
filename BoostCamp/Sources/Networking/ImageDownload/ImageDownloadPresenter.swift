//
//  ImageDownloaderPresenter.swift
//  BoostCamp
//
//  Created by Xvezda on 12/9/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import Foundation

class ImageDownloaderPresenter: ImageDownloaderPresenterProtocol {
  var view: ImageDownloaderViewProtocol?
  var interactor: ImageDownloaderInputInteractorProtocol?
  var wireframe: ImageDownloaderWireframeProtocol?
  
  func viewDidLoad() {}
  
  func downloadImage(by url: String) {
    interactor?.getImage(by: url)
  }
}

extension ImageDownloaderPresenter: ImageDownloaderOutputInteractorProtocol {
  func imageDidFetch(image: DLImage) {
    view?.showImage(with: image)
  }
}
