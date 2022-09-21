//
//  NetworkRouter.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-01.
//

import Foundation
import Alamofire
import WebKit

enum NetworkRouter: URLRequestConvertible {

  case getVoucherByVoucherCode(String)
  case login(LoginUserModel)
  case getItemByDeviceId(String)
  case createItem(CreateItemModel)
  case createItemDiagnosticReport(String, DiagnosticReportModel)
  
  // upload image
  case uploadImage(String, String, Data)
   
  // sensor event: include sensor test & ddd
  case sensorTests
  case sensorEvent(String, SensorEventAPIDataModel)
  case sensorReadings(String, String, [DeviceMotionDataModel])
  case sensorAudio(String, String, String)
  
  //
  case surveys([String: Any])
  case offers
  case rewardScreen
  
  var method: HTTPMethod {
    switch self {
    case .getVoucherByVoucherCode, .getItemByDeviceId, .sensorTests, .offers, .rewardScreen:
      return .get
    case .login, .createItem, .sensorReadings, .sensorAudio, .createItemDiagnosticReport, .uploadImage, .surveys:
      return .post
    case .sensorEvent:
      return .put
    }
  }
  
  var path: String {
    switch self {
    case .getVoucherByVoucherCode(let code):
      return "/vouchers/\(code)"
    case .login:
      return "/auth/token"
    case .getItemByDeviceId(let deviceId):
      return "/items?deviceId=\(deviceId)"
    case .createItem:
      return "/items"
    case .createItemDiagnosticReport(let itemId, _):
      return "/items/\(itemId)/diagnostics"
    case .uploadImage(let itemId, let path, _):
      return "/items/\(itemId)/diagnostics/\(path)"
    case .sensorTests:
      return "/sensor-tests"
    case .sensorEvent(let itemId, _):
      return "/items/\(itemId)"
    case .sensorReadings(let itemId, let sensorEventId, _):
      return "/items/\(itemId)/events/\(sensorEventId)/readings"
    case .sensorAudio(let itemId, let sensorEventId, let createdAt):
      return "/items/\(itemId)/clips/sound/\(sensorEventId)?createdAt=\(createdAt)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    case .surveys:
      return "/surveys"
    case .offers:
      return "/offers/registration?simplify"
    case .rewardScreen:
      return "/offers/reward-screen?simplify"
    }
  }
  
  var headers: [String: String]? {
    switch self {
    case .getVoucherByVoucherCode, .login:
      if let userAgent = WKWebView().value(forKey: "userAgent"), let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        return ["User-Agent": "Warranty Life Diagnostic/\(appVersion) \(userAgent)"]
      }
      return nil
    case .getItemByDeviceId, .createItem, .sensorEvent, .sensorAudio, .sensorReadings, .sensorTests, .createItemDiagnosticReport, .uploadImage, .surveys, .offers, .rewardScreen:
      return UserDefaults.standard.dictionary(forKey: kHttpHeaders) as? [String: String]
    }
  }
  
  var parameters: Parameters? {
    switch self {
    case .getVoucherByVoucherCode, .getItemByDeviceId, .sensorAudio, .sensorTests, .uploadImage:
      return nil
    case .login(let model):
      return model.params
    case .createItem(let model):
      return model.params
    case .createItemDiagnosticReport(_, let model):
      return model.params
    case .sensorEvent(_, let model):
      return model.event.params
    case .sensorReadings(_, _, let models):
      return models.map({ $0.params}).asParameters()
    case .surveys(let params):
      return params
    case .offers, .rewardScreen:
      if let countryISO = UserDefaults.standard.string(forKey: "countryISO"),
         let stateISO = UserDefaults.standard.string(forKey: "stateISO"),
         let city = UserDefaults.standard.string(forKey: "city"),
         let zip = UserDefaults.standard.string(forKey: "zip") {
        return ["country": countryISO, "state": stateISO, "city": city, "zip": zip]
      }
      return nil
    }
  }
  
  var encoding: ParameterEncoding {
    switch self {
    case .getVoucherByVoucherCode, .login, .getItemByDeviceId, .sensorAudio, .sensorTests, .uploadImage, .offers, .rewardScreen:
      return URLEncoding.default
    case .createItem, .sensorEvent, .createItemDiagnosticReport, .surveys:
      return JSONEncoding.default
    case .sensorReadings:
      return ArrayEncoding.default
    }
  }
  
  var multipartFormData: MultipartFormData {
    let multipartFormData = MultipartFormData()
    switch self {
    case .uploadImage(_, _, let imageData):
      let fileName = Helper.randomString()
      multipartFormData.append(imageData, withName: "image", fileName: fileName, mimeType: "image/jpg")
    default:
      break
    }

    return multipartFormData
  }
  
  func asURLRequest() throws -> URLRequest {
    guard let url = URL(string: BASE_URL + path) else {
      throw NetworkError.invalidURL
    }

    var urlRequest = URLRequest(url: url)
    urlRequest.method = method
    urlRequest.allHTTPHeaderFields = headers
    urlRequest.timeoutInterval = 60

    return try encoding.encode(urlRequest, with: parameters)
  }
}
