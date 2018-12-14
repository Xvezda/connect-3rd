//
//  Errors.swift
//  BoostCamp
//
//  Created by Xvezda on 12/8/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import Foundation

protocol BoxOfficeError: Error {}

public enum CommonError: BoxOfficeError  {
  case emptyDomain
}

public enum NetworkingError: BoxOfficeError {
  case requestFailed
  case parseFailed
  case emptyResponse
}
