//
//  SensorTestMotionHandler.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-01.
//

import UIKit
import Foundation
import CoreMotion

extension SensorTestViewController {

  func startDeviceMotionUpdate() {
    motionManager.deviceMotionUpdateInterval = 1.0 / 95
    motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical, to: .main) { deviceMotion, error in
      guard error == nil else {
        Logger.logFatalError(title: #function, error)
        // TODO: how to handle error here?
        return
      }
      
      guard let deviceMotion = deviceMotion else {
        Logger.logFatalError(title: #function)
        // TODO: device motion object not returned? guard to handle here!
        return
      }

      guard self.userStartsTest else {
        return
      }

      // user tapped start button, check if device is stable(stableDuration > 1s), then start test
      if self.isDeviceStableAndHorizontalAndOrientationIsCorrect(deviceMotion: deviceMotion){
        if !self.isTestRunning() {
          self.startTesting()
        }
      } else {
        if self.isTestRunning() {
          self.deviceMovementDetectedDuringTest() // only stop test if test is running
        }
      }
      
      guard self.isTestRunning() else {
        return
      }
      
      guard self.currentSensorTestPhaseOrder != nil else {
        return
      }
  
      self.giveMeTheData(deviceMotion: deviceMotion)
    }

    if CMAltimeter.isRelativeAltitudeAvailable() {
      altimeter.startRelativeAltitudeUpdates(to: .main) { altitudeData, error in
        guard error == nil else {
          Logger.logFatalError(title: #function, error)
          // TODO: how to handle error here?
          return
        }
      
        self.altitudeData = altitudeData
      }
    }
  }
  
  func stopDevieMotionUpdate() {
    motionManager.stopDeviceMotionUpdates()
    altimeter.stopRelativeAltitudeUpdates()
  }
}

//
// MARK: - Helper

extension SensorTestViewController {
  func isDeviceStableAndHorizontalAndOrientationIsCorrect(deviceMotion: CMDeviceMotion) -> Bool {
//    #warning("")
//    #if DEBUG
//    return true
//    #else
    if isHorizontal(pitch: deviceMotion.attitude.pitch) &&
       isStable(deviceMotion: deviceMotion) &&
        isDeviceOrientationCorrect(pitch: deviceMotion.attitude.pitch, roll: deviceMotion.attitude.roll) {
      stableDuration += 1
    } else {
      stableDuration = 0
    }
    return stableDuration > 175 // around 2.2 seconds
//    #endif
  }

  private func isStable(deviceMotion: CMDeviceMotion) -> Bool {
    let diff: Double = 2
    let accelection = accelection(deviceMotion: deviceMotion)
    return accelection > gravity - diff && accelection < gravity + diff
  }
  
  private func isHorizontal(pitch: Double) -> Bool {
    let diff: Double = 6.5 // 5 degree
    return pitch * 180 / Double.pi < diff && pitch * 180 / Double.pi > -diff
  }
  
  private func accelection(deviceMotion: CMDeviceMotion) -> Double {
    let x = (deviceMotion.userAcceleration.x + deviceMotion.gravity.x) * 10
    let y = (deviceMotion.userAcceleration.y + deviceMotion.gravity.y) * 10
    let z = (deviceMotion.userAcceleration.z + deviceMotion.gravity.z) * 10
    
    return (x * x + y * y + z * z).squareRoot()
  }
  
  private func isDeviceOrientationCorrect(pitch: Double, roll: Double) -> Bool {
    #if DEBUG
    return true
    #endif
    
    let orientation = DeviceOrientation.currentOrientation(pitch: pitch, roll: roll)
    switch orientation {
    case .faceUp:
      return !isFaceDown
    case .faceDown:
      return isFaceDown
    case .unknown:
      return false
    }
  }
}

