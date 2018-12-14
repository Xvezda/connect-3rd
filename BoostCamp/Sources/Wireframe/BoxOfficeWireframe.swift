//
//  BoxOfficeWireframe.swift
//  BoostCamp
//
//  Created by Xvezda on 12/8/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import Foundation

class BoxOfficeWireframe: BoxOfficeWireframeProtocol {
  static func createMovieList(ref: BoxOfficeMovieListView) {
    let presenter: BoxOfficePresenterProtocol &
                   BoxOfficeOutputInteractorProtocol = BoxOfficePresenter()

    ref.presenter = presenter
    
    ref.presenter?.view = ref
    ref.presenter?.wireframe = BoxOfficeWireframe()
    ref.presenter?.interactor = BoxOfficeInteractor()

    ref.presenter?.interactor?.presenter = presenter
  }
}
