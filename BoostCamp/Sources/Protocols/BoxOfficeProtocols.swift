//
//  BoxOfficeProtocols.swift
//  BoostCamp
//
//  Created by Xvezda on 12/8/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import Foundation

protocol BoxOfficeViewProtocol: class {
  func showMovieList(with movies: [Movie])
  func pushMovieDetail(of: Movie)
  func showAlert(message: String)
  func showIndicator()
  func hideIndicator()
}

protocol BoxOfficeInputInteractorProtocol: class {
  var presenter: BoxOfficeOutputInteractorProtocol? { get set }

  func getMovieList(by order: SortMethod)
  func getMovieDetail(of movie: Movie)
}

protocol BoxOfficeOutputInteractorProtocol: class {
  func movieListDidFetch(movieList: [Movie])
  func movieDetailDidFetch(detail: Movie)
  func movieGetError(message: String)
}

protocol BoxOfficePresenterProtocol: class {
  var view: BoxOfficeViewProtocol? { get set }
  var interactor: BoxOfficeInputInteractorProtocol? { get set }
  var wireframe: BoxOfficeWireframeProtocol? { get set }

  func viewDidLoad()
  func loadMovieList(by order: SortMethod)
  func loadMovieDetail(of movie: Movie)
}

protocol BoxOfficeWireframeProtocol: class {
  static func createMovieList(ref: BoxOfficeMovieListView)
}
