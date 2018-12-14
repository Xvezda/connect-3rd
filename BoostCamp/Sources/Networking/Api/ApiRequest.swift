//
//  ApiRequest.swift
//  BoostCamp
//
//  Created by Xvezda on 12/8/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import Foundation

// API with JSON parse class
class ApiRequest: Request {
  static func parseJson(data: AnyObject) -> Json {
    do {
      return try JSONSerialization
        .jsonObject(with: data as? Data ?? Data(),
                      options: .mutableContainers) as? Json ?? Json()
    } catch {
      return Json()
    }
  }
}
