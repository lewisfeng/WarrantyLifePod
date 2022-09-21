//
//  CreateItemModel.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-06.
//

import Foundation
import UIKit

struct CreateItemModel: Codable {
  var deviceId = UserDefaults.standard.string(forKey: kDeviceId)!
  var categoryId = UIDevice.current.userInterfaceIdiom == .phone ? "95" : "92"
  var manufacturerName = "Apple"
  var model = UIDevice.modelName
  var mpn = UIDevice.mpn
}
