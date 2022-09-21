//
//  Connectivity.swift
//  DDT
//
//  Created by YI BIN FENG on 2022-02-24.
//  Copyright © 2022 Warranty Life. All rights reserved.
//

import Foundation
import Alamofire

// MARK:
// MARK: Connectivity
struct Connectivity {
  static let shared = NetworkReachabilityManager()!
  static var isConnectedToInternet: Bool {
    return shared.isReachable
  }
}
