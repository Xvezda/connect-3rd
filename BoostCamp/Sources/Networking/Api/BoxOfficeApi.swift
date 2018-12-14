//
//  BoxOfficeApi.swift
//  BoostCamp
//
//  Created by Xvezda on 12/8/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import Foundation

final class BoxOfficeApi: ApiRequest {
  // Parse info.plist to get allowed domain information
  static var allowedDomain = { () -> String? in
    var obj: Dictionary<String, Any>?
    if let infoDic: [String: Any] = Bundle.main.infoDictionary {
      if let obj: Dictionary = infoDic["NSAppTransportSecurity"] as? Dictionary<String, Any> {
        if let obj: Dictionary =
          obj["NSExceptionDomains"] as?
            Dictionary<String, Any> {
          return Array(obj.keys)[0]
        }
      }
    }
    return "connect-boxoffice.run.goorm.io"  // FIXME: Remove this line when release
    //return nil
  }()
  
  static func requestMovieList(by order: SortMethod, callback: @escaping ([Movie]) -> Void) {
    var orderType: String!
    switch order {
    case .AdvanceRate:
      orderType = "0"
    case .Curation:
      orderType = "1"
    case .ReleaseDate:
      orderType = "2"
    }
    if let baseUrl = allowedDomain {
      request(URL(string: "http://\(baseUrl)/movies?order_type=\(orderType ?? "0")")!, { (data: AnyObject, err: String) in
        if err.isEmpty == false { callback([Movie]()) }
        let json = ApiRequest.parseJson(data: data)
        var movies = [Movie]()
        if let arr = json["movies"] as? NSArray {
          for item in arr {
            var obj = item as? Json
            var info = Movie()
            
            info.id = (obj!["id"] as? String)
            info.date = (obj!["date"] as? String)
            info.title = (obj!["title"] as? String)
            info.thumb = (obj!["thumb"] as? String)
            info.grade = (obj!["grade"] as? Int)
            info.reservationRate = (obj!["reservation_rate"] as? Double)
            info.reservationGrade = (obj!["reservation_grade"] as? Int)
            info.userRating = (obj!["user_rating"] as? Double)

            movies.append(info)
          }
          callback(movies)
        } else {
          callback([Movie]())
        }
      })
    } else {
      callback([Movie]())
    }
  }
  
  static func requestMovieDetail(of movie: Movie, callback: @escaping (Movie) -> Void) {
    let movieId = movie.id!
    if let baseUrl = allowedDomain {
      request(URL(string: "http://\(baseUrl)/movie?id=\(movieId)")!, { (data: AnyObject, err: String) in
        if err.isEmpty == false { callback(Movie()) }
        let json = ApiRequest.parseJson(data: data)
        let data = json
        
        var info = Movie()
        info.id = data["id"] as? String
        info.date = data["date"] as? String
        info.title = data["title"] as? String
        info.genre = data["genre"] as? String
        info.image = data["image"] as? String
        info.actor = data["actor"] as? String
        info.director = data["director"] as? String
        info.synopsis = data["synopsis"] as? String
        info.grade = data["grade"] as? Int
        info.reservationGrade = data["reservation_grade"] as? Int
        info.reservationRate = data["reservation_rate"] as? Double
        info.userRating = data["user_rating"] as? Double
        info.audience = data["audience"] as? Int
        info.duration = data["duration"] as? Int
        
        callback(info)
      })
    } else {
      callback(Movie())
    }
  }
  
  static func requestMovieCommentList(of movie: Movie, callback: @escaping ([Comment]) -> Void) {
    let movieId = movie.id!
    if let baseUrl = allowedDomain {
      request(
        URL(string: "http://\(baseUrl)/comments?movie_id=\(movieId)")!,
            { (data: AnyObject, err: String) in
        if err.isEmpty == false { return callback([Comment]()) }
        let json = ApiRequest.parseJson(data: data)
        var comments = [Comment]()
        if let arr = json["comments"] as? NSArray {
          for item in arr {
            let obj = item as? Json
            var temp = Comment()
            temp.movieId = (obj!["movie_id"] as? String)
            temp.writer = (obj!["writer"] as? String)
            temp.timestamp = (obj!["timestamp"] as? Double)
            temp.rating = (obj!["rating"] as? Double)
            temp.contents = (obj!["contents"] as? String)

            comments.append(temp)
          }
          callback(comments)
        } else {
          callback([Comment]())
        }
      })
    } else {
      callback([Comment]())
    }
  }
}
