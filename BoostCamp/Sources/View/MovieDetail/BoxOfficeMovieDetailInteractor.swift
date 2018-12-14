//
//  BoxOfficeMovieDetailInteractor.swift
//  BoostCamp
//
//  Created by Xvezda on 12/11/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import Foundation

class BoxOfficeMovieDetailInteractor: BoxOfficeMovieDetailInputInteractorProtocol {
  weak var presenter: BoxOfficeMovieDetailOutputInteractorProtocol?

  func getMovieCommentList(by movie: Movie) {
    BoxOfficeApi.requestMovieCommentList(of: movie, callback: plugMovieCommentList)
  }
  
  func plugMovieCommentList(_ commentList: [Comment]) {
    if commentList.isEmpty {
      presenter?.commentGetError(message: "load_movie_comment_error".localized)
    } else {
      presenter?.movieCommentListDidFetch(with: commentList)
    }
  }
}
