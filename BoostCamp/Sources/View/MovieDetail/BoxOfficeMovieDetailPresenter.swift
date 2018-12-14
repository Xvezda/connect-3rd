//
//  BoxOfficeMovieDetailPresenter.swift
//  BoostCamp
//
//  Created by Xvezda on 12/9/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import Foundation

class BoxOfficeMovieDetailPresenter: BoxOfficeMovieDetailPresenterProtocol {
  var view: BoxOfficeMovieDetailViewProtocol?
  var wireframe: BoxOfficeMovieDetailWireframeProtocol?
  var interactor: BoxOfficeMovieDetailInputInteractorProtocol?
  
  var movie: Movie?
  
  func viewDidLoad() {
    view?.showMovieDetail(with: movie!)
  }

  func loadCommentList() {
    view?.showIndicator()
    interactor?.getMovieCommentList(by: movie!)
  }
  
  func loadFullSizeMoviePoster() {
    view?.showFullSizeMoviePoster(with: movie!)
  }
}

extension BoxOfficeMovieDetailPresenter: BoxOfficeMovieDetailOutputInteractorProtocol {
  func movieCommentListDidFetch(with comments: [Comment]) {
    view?.hideIndicator()
    view?.showCommentList(with: comments)
  }
  
  func commentGetError(message: String) {
    view?.hideIndicator()
    view?.showAlert(message: message.localized)
  }
}
