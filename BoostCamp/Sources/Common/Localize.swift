//
//  Localize.swift
//  BoostCamp
//
//  Created by Xvezda on 12/8/18.
//  Copyright © 2018 Xvezda. All rights reserved.
//

import Foundation

extension String {
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
}
