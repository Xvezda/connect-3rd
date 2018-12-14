//
//  BoxOfficeMovieDetailWireframe.swift
//  BoostCamp
//
//  Created by Xvezda on 12/9/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import Foundation

class BoxOfficeMovieDetailWireframe: BoxOfficeMovieDetailWireframeProtocol {
  static func createMovieDetailModule(ref: BoxOfficeMovieDetailViewProtocol, with movie: Movie) {
    let presenter: BoxOfficeMovieDetailPresenter &
        BoxOfficeMovieDetailOutputInteractorProtocol = BoxOfficeMovieDetailPresenter()
    
    presenter.movie = movie
    ref.presenter = presenter
    ref.presenter?.view = ref
    ref.presenter?.wireframe = BoxOfficeMovieDetailWireframe()
    ref.presenter?.interactor = BoxOfficeMovieDetailInteractor()
    ref.presenter?.interactor?.presenter = presenter
  }
}
