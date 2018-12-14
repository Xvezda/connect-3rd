//
//  Request.swift
//  BoostCamp
//
//  Created by Xvezda on 12/8/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import Foundation

// AppleFramework network request class
class Request {
  static let urlSession = URLSession.shared
  static func request(
    _ url: URL,
    _ callback: @escaping
    (AnyObject, String) -> Void) {
    let getRequest = URLRequest(url: url)
    let task = urlSession.dataTask(
      with: getRequest as URLRequest,
      completionHandler: { data, res, err in
        guard err == nil else {
          return callback("" as AnyObject, "network_error".localized)
        }
        guard let data = data else {
          return callback("" as AnyObject, "network_error".localized)
        }
        return callback(data as AnyObject, "")
    })
    task.resume()
  }
}
