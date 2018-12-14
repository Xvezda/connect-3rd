//
//  ImageDownloaderWireframe.swift
//  BoostCamp
//
//  Created by Xvezda on 12/9/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import Foundation

class ImageDownloaderWireframe: ImageDownloaderWireframeProtocol {
  static func createImageDownloaderModule(ref: ImageDownloaderViewProtocol, storage: ImageStorage) {
    let presenter: ImageDownloaderPresenterProtocol &
        ImageDownloaderOutputInteractorProtocol = ImageDownloaderPresenter()
    ref.presenter = presenter
    ref.presenter?.view = ref
    ref.presenter?.interactor = ImageDownloaderInteractor(storage: storage)
    ref.presenter?.interactor?.presenter = presenter
    ref.presenter?.wireframe = ImageDownloaderWireframe()
  }
}
