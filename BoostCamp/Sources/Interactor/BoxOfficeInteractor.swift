//
//  BoxOfficeInteractor.swift
//  BoostCamp
//
//  Created by Xvezda on 12/8/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import Foundation

class BoxOfficeInteractor: BoxOfficeInputInteractorProtocol {
  weak var presenter: BoxOfficeOutputInteractorProtocol?

  func getMovieList(by order: SortMethod) {
    BoxOfficeApi.requestMovieList(by: order, callback: plugMovieList)
  }
  
  private func plugMovieList(_ movies: [Movie]) {
    if movies.isEmpty {
      presenter?.movieGetError(message: "network_error".localized)
    }
    presenter?.movieListDidFetch(movieList: movies)
  }

  func getMovieDetail(of movie: Movie) {
    BoxOfficeApi.requestMovieDetail(of: movie, callback: plugMovieDetail)
  }
  
  private func plugMovieDetail(_ detail: Movie) {
    if let _ = detail.id {  // ID always required
      presenter?.movieDetailDidFetch(detail: detail)
    } else {
      presenter?.movieGetError(message: "load_movie_detail_error".localized)
    }
  }
}
