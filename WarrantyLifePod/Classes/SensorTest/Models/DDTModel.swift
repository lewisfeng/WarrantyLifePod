//
//  DDTModel.swift
//  DDT
//
//  Created by YI BIN FENG on 2022-02-10.
//  Copyright © 2022 Warranty Life. All rights reserved.
//

import Foundation

struct DDTModel: Decodable {
  var numberOfRuns: Int = 1
  let surfaceHardnessType: Int
  let note: String
  let isFaceUp: String
}
