//
//  DeviceMotionDataModel.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-01.
//

import Foundation
import CoreMotion

struct DeviceMotionDataModels: Codable {
  var models: [DeviceMotionDataModel]
}

// This model only contains

struct DeviceMotionDataModel: Codable {
  var readingAt: String
  
  var accelerationX: Double
  var accelerationY: Double
  var accelerationZ: Double
  var gyroscopeX: Double
  var gyroscopeY: Double
  var gyroscopeZ: Double
  var magnetometerX: Double
  var magnetometerY: Double
  var magnetometerZ: Double
  var pitch: Double
  var roll: Double
  var yaw: Double
  var relativeAltitude: Double
  var pressure: Double
  var soundClipOffsetMs: Int?
  var phase: Int?
  var subphase: Double?
  
  init(deviceMotion: CMDeviceMotion, altitudeData: CMAltitudeData?) {
    readingAt = NetworkHelper.getTimeStamp(date: Date())

    accelerationX = deviceMotion.userAcceleration.x + deviceMotion.gravity.x
    accelerationY = deviceMotion.userAcceleration.y + deviceMotion.gravity.y
    accelerationZ = deviceMotion.userAcceleration.z + deviceMotion.gravity.z
    
    // WL-3203: https://warrantylife.atlassian.net/jira/software/c/projects/WL/issues/WL-3203
    // convert from G-forces to meters-per-second-squared
    let mpss: Double = -9.81
    accelerationX *= mpss
    accelerationY *= mpss
    accelerationZ *= mpss
    
    gyroscopeX = deviceMotion.rotationRate.x
    gyroscopeY = deviceMotion.rotationRate.y
    gyroscopeZ = deviceMotion.rotationRate.z
    
    magnetometerX = deviceMotion.magneticField.field.x
    magnetometerY = deviceMotion.magneticField.field.y
    magnetometerZ = deviceMotion.magneticField.field.z
    
    pitch = deviceMotion.attitude.pitch * 180 / .pi // covert radians to degree
    roll  = deviceMotion.attitude.roll  * 180 / .pi
    yaw   = deviceMotion.attitude.yaw   * 180 / .pi
    
    relativeAltitude = altitudeData?.relativeAltitude.doubleValue ?? -1
    pressure = altitudeData?.pressure.doubleValue ?? -1
  }
  
  init(deviceMotion: CMDeviceMotion, altitudeData: CMAltitudeData?, phaseId: Int?, toneFrequency: Double, currentRecordingTime: TimeInterval) {
    self.init(deviceMotion: deviceMotion, altitudeData: altitudeData)
    
    phase = phaseId ?? -1
    
    subphase = toneFrequency != -1 ? toneFrequency : nil
    
    soundClipOffsetMs = Int(currentRecordingTime * 1000)
  }
}
