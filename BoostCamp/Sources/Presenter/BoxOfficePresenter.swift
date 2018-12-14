//
//  BoxOfficePresenter.swift
//  BoostCamp
//
//  Created by Xvezda on 12/8/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import Foundation

class BoxOfficePresenter: BoxOfficePresenterProtocol {
  var view: BoxOfficeViewProtocol?
  var presenter: BoxOfficePresenterProtocol?
  var wireframe: BoxOfficeWireframeProtocol?
  var interactor: BoxOfficeInputInteractorProtocol?

  func viewDidLoad() {
    loadMovieList()
  }
  
  func loadMovieList(by order: SortMethod = .AdvanceRate) {
    interactor?.getMovieList(by: order)
    DispatchQueue.main.async {
      self.view?.showIndicator()
    }
  }
  
  func loadMovieDetail(of movie: Movie) {
    interactor?.getMovieDetail(of: movie)
    DispatchQueue.main.async {
      self.view?.showIndicator()
    }
  }
}

extension BoxOfficePresenter: BoxOfficeOutputInteractorProtocol {
  func movieListDidFetch(movieList: [Movie]) {
    view?.showMovieList(with: movieList)
  }
  
  func movieDetailDidFetch(detail: Movie) {
    view?.pushMovieDetail(of: detail)
  }

  func movieGetError(message: String) {
    view?.hideIndicator()
    view?.showAlert(message: message.localized)
  }
}
