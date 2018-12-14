//
//  ImageDownloaderProtocol.swift
//  BoostCamp
//
//  Created by Xvezda on 12/9/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import Foundation

protocol ImageDownloaderViewProtocol: class {
  var presenter: ImageDownloaderPresenterProtocol? { get set }
  func showImage(with image: DLImage)
}

protocol ImageDownloaderPresenterProtocol: class {
  var view: ImageDownloaderViewProtocol? { get set }
  var interactor: ImageDownloaderInputInteractorProtocol? { get set }
  var wireframe: ImageDownloaderWireframeProtocol? { get set }
  
  func viewDidLoad()
  func downloadImage(by url: String)
}

protocol ImageDownloaderWireframeProtocol: class {
  static func createImageDownloaderModule(ref: ImageDownloaderViewProtocol, storage: ImageStorage)
}

protocol ImageDownloaderInputInteractorProtocol: class {
  var presenter: ImageDownloaderOutputInteractorProtocol? { get set }
  
  func getImage(by url: String)
}

protocol ImageDownloaderOutputInteractorProtocol: class {
  func imageDidFetch(image: DLImage)
}
