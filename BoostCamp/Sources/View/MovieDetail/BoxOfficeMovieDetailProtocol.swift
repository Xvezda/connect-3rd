//
//  BoxOfficeMovieDetailProtocol.swift
//  BoostCamp
//
//  Created by Xvezda on 12/9/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import Foundation

protocol BoxOfficeMovieDetailViewProtocol: class {
  var presenter: BoxOfficeMovieDetailPresenterProtocol? { get set }
  
  func showMovieDetail(with movie: Movie)
  func showCommentList(with comments: [Comment])
  func showFullSizeMoviePoster(with movie: Movie)
  func showAlert(message: String)
  func showIndicator()
  func hideIndicator()
}

protocol BoxOfficeMovieDetailPresenterProtocol: class {
  var view: BoxOfficeMovieDetailViewProtocol? { get set }
  var wireframe: BoxOfficeMovieDetailWireframeProtocol? { get set }
  var interactor: BoxOfficeMovieDetailInputInteractorProtocol? { get set }
  
  func viewDidLoad()
  func loadCommentList()
  func loadFullSizeMoviePoster()
}

protocol BoxOfficeMovieDetailWireframeProtocol: class {
  static func createMovieDetailModule(ref: BoxOfficeMovieDetailViewProtocol, with movie: Movie)
}

protocol BoxOfficeMovieDetailOutputInteractorProtocol: class {
  func movieCommentListDidFetch(with comments: [Comment])
  func commentGetError(message: String)
}

protocol BoxOfficeMovieDetailInputInteractorProtocol: class {
  var presenter: BoxOfficeMovieDetailOutputInteractorProtocol? { get set }
  
  func getMovieCommentList(by movie: Movie)
}
