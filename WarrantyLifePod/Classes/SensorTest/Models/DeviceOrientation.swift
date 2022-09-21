//
//  DeviceOrientation.swift
//  DDT
//
//  Created by YI BIN FENG on 2022-02-15.
//  Copyright © 2022 Warranty Life. All rights reserved.
//

import UIKit

enum DeviceOrientation: CaseIterable {
  case faceUp, faceDown, unknown

  static func currentOrientation(pitch: Double, roll: Double) -> DeviceOrientation {
    for orientation in DeviceOrientation.allCases {
      if orientation.isOrientedTowards(pitch: pitch, roll: roll) {
        return orientation
      }
    }
    return .unknown
  }
}

extension DeviceOrientation {
  
  private var minPitch: Double {
    switch self {
      case .faceUp:   return 0
      case .faceDown: return 0
      case .unknown:  return 15
    }
  }
  
  private var maxPitch: Double {
    switch self {
      case .faceUp:   return 45
      case .faceDown: return 45
      case .unknown:  return 90
    }
  }
  
  private var minRoll: Double {
    switch self {
      case .faceUp:   return 0
      case .faceDown: return 135
      case .unknown:  return 15
    }
  }
  
  private var maxRoll: Double {
    switch self {
      case .faceUp:   return 45
      case .faceDown: return 180
      case .unknown : return 165
    }
  }
  
  private func isOrientedTowards(pitch:Double, roll:Double) -> Bool {
    let pitchPos = abs(pitch * 180 / .pi) // covert radians to degree
    let rollPos  = abs(roll  * 180 / .pi)
    return isInRange(candidate: pitchPos, min: minPitch, max: maxPitch) && isInRange(candidate: rollPos, min: minRoll, max: maxRoll)
  }
  
  private func isInRange(candidate: Double, min: Double, max: Double) -> Bool {
    return candidate >= min && candidate <= max
  }
}
