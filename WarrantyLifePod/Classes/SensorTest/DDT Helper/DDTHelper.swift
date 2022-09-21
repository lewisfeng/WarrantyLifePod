//
//  DDTHelper.swift
//  DDT
//
//  Created by YI BIN FENG on 2022-02-10.
//  Copyright © 2022 Warranty Life. All rights reserved.
//

import Foundation

/*
  |   50 | Softer padded surface (Couch, Mattress...)                          |
  |   77 | Skin (e.g. in-hand)                                                 |
  |   99 | Hard plastic over silicone/neoprene/cork                            |
  |  100 | Soft Padded surface (Carpet, Cork, neoprene, silicone mat,...)      |
  |  110 | Silicone                                                            |
  |  120 | Soft wood (larch, fir, NA cherry/walnut,...)                        |
  |  130 | Hard wood (Oak, Maple,...)                                          |
  |  140 | Extremely hard wood (Brazilian cherry/teak/walnut, Purple heart,... |
  |  250 | Book or stack of paper                                              |
  |  400 | Leather                                                             |
  | 1000 | Wood (unknown type)                                                 |
  | 1500 | Asphalt                                                             |
  | 1750 | Plastic                                                             |
  | 2000 | Aluminum                                                            |
  | 3501 | Marble                                                              |
  | 5000 | Glass                                                               |
  | 6500 | Steel
*/

enum SurfaceType: String {
  case t50   = "Softer padded surface (Couch, Mattress...)"
  case t77   = "Skin (e.g. in-hand) "
  case t99   = "Hard plastic over silicone/neoprene/cork "
  case t100  = "Soft Padded surface (Carpet, Cork...)"
  case t110  = "Silicone"
  case t120  = "Soft wood (larch, fir, NA cherry/walnut,...)"
  case t130  = "Hard wood (Oak, Maple,...)  "
  case t140  = "Extremely hard wood (cherry/teak/walnut...)"
  case t250  = "Book or stack of paper "
  case t400  = "Leather"
  case t1000 = "Wood (unknown type)"
  case t1500 = "Asphalt"
  case t1750 = "Plastic"
  case t2000 = "Aluminum"
  case t3501 = "Marble"
  case t5000 = "Glass"
  case t6500 = "Steel"
  case t9999 = "unknown type"
  
  static func type(from hardness: Int) -> SurfaceType {
    if hardness == 50 {
      return .t50
    } else if hardness == 77 {
      return .t77
    } else if hardness == 99 {
      return .t99
    } else if hardness == 100 {
      return .t100
    } else if hardness == 110 {
      return .t110
    } else if hardness == 120 {
      return .t120
    } else if hardness == 130 {
      return .t130
    } else if hardness == 140 {
      return .t140
    } else if hardness == 250 {
      return .t250
    } else if hardness == 400 {
      return .t400
    } else if hardness == 1000 {
      return .t1000
    } else if hardness == 1500 {
      return .t1500
    } else if hardness == 1750 {
      return .t1750
    } else if hardness == 2000 {
      return .t2000
    } else if hardness == 3501 {
      return .t3501
    } else if hardness == 5000 {
      return .t5000
    } else if hardness == 6500 {
      return .t6500
    } else {
      return t9999
    }
  }
}
