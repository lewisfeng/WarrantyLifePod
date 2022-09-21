//
//  Extensions.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-04.
//

import Foundation
import UIKit

let kSensorData = "SavedSensorEventAPIDataModels"
let kSensorTestData = "SensorTestData"
let kSensorTestModel = "SensorTestModel"
let kSensorTest3 = "Sensor Test 3"
let kLastDropDate = "Last Drop Date"
let kHttpHeaders = "HTTP Headers"
let kItemId = "Item ID"
let kDeviceId = "Device ID"
let sensorTestDataKey = "Sensor Test Data Key"
let kFinishedCaseDetectionOnDrop = "Finished Case Detection On Drop"
let vibratinDuration: Double = 0.575

extension Encodable {
    subscript(key: String) -> Any? {
        return params[key]
    }
    var params: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}

func instantiate<T: Decodable>(jsonString: String) -> T? {
    return try? JSONDecoder().decode(T.self, from: jsonString.data(using: .utf8)!)
}

extension UIViewController {
  
  func showNetworkError(_ error: NetworkError) {
    let alertController = UIAlertController(title: "Network Error", message: error.rawValue, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertController, animated: true, completion: nil)
  }
}

public extension UIDevice {
  
  static let mpn: String = {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8 , value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    return identifier
  }()
}
