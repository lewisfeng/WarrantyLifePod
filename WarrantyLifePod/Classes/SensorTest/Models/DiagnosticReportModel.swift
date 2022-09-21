//
//  DiagnosticReportModel.swift
//  DDT
//
//  Created by YI BIN FENG on 2022-02-09.
//  Copyright © 2022 Warranty Life. All rights reserved.
//

import Foundation
import UIKit

struct DiagnosticReportModel: Codable {
  var imei: String?
  var brand = "Apple"
  var resultCode = "P"
  var sim = "8923440000000000003"
  var appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
  var osVersion = UIDevice.current.systemVersion
  var screenResolution = "\(UIScreen.main.bounds.size.width) x \(UIScreen.main.bounds.size.height) pixels"
  var storage = UIDevice.current.getTotalDiskSpaceInGB()
  var storageUsed = UIDevice.current.usedDiskSpaceInGB
  var ram = ProcessInfo.init().physicalMemory
  var model = UIDevice.modelName
  var mpn = UIDevice.mpn
  var sensorTestId: String?
  var sensorTestSensorEventId: String?
  var caseBundlePurchased: Bool?
  var bundledCaseApplied: Bool?
  var caseApplied: String?
  var caseBrand: String?
  
  private(set) var referenceImageData: Data? = {
    return UserDefaults.standard.data(forKey: "ReferenceImage")
  }()
  private(set) var testImageData: Data? = {
    return UserDefaults.standard.data(forKey: "TestImage")
  }()
}
