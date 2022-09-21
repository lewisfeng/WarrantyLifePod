//
//  SensorEventDataModel.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-07.
//

import Foundation
import UIKit

// This model is for API use: sensor event, sensor readings, recorded audio file

struct SensorEventAPIDataModel: Codable {
  var event: SensorEvent
  var readings: [DeviceMotionDataModel]
  var audio: URL?
  
  // offline use
  var retryDate = Date()
  var retryCount = 0
  /*
   logic of retry
   1. max retry count = 5
   2. first call
      frist retry in 5 mins
      second retry in 1 hour
      thrid retry in 8 hours
      fouth retry in 24 hours
      delete
   */
  
  init(eventType: Int, data: [DeviceMotionDataModel]) {
    event = SensorEvent(sensorEventType: eventType)
    readings = data
  }
  
  init(event: SensorEvent, readings: [DeviceMotionDataModel], audio: URL? = nil) {
    self.event = event
    self.readings = readings
    self.audio = audio
  }
}

struct SensorEvent: Codable {
  var eventAt: String
  var sensorEventType: Int
  var volumeSetting: Int?
  var sensorTestId: String?
  var dropJsVersion = "1.0.4"
  var notificationToken = UserDefaults.standard.string(forKey: "FCM Token")
  var deviceId = UserDefaults.standard.string(forKey: "SavedDeviceId")
  var platformVersion = UIDevice.current.systemVersion
  var latitude: Double?
  var longitude: Double?
  var appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
  
  init(eventAt: String = Helper.getTimeStamp(), sensorEventType: Int, volumeSetting: Int? = nil, sensorTestId: String? = nil) {
    self.eventAt = eventAt
    self.sensorEventType = sensorEventType
    self.volumeSetting = volumeSetting
    self.sensorTestId = sensorTestId

    if LocationManager.isAuthorizated,
       let latitude = LocationManager.shared.coordinate?.latitude,
       let longitude = LocationManager.shared.coordinate?.longitude {
      self.latitude = latitude; self.longitude = longitude
    }
  }
}
