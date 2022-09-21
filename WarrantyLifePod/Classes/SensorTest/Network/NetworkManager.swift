//
//  NetworkManager.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-01.
//

import Foundation
import Alamofire

class NetworkManager {
  static let shared = NetworkManager()
  
  func createItemDiagnosticReport(itemId: String, model: DiagnosticReportModel, completion: @escaping(Result<Void, NetworkError>) -> Void) {
    AF.request(NetworkRouter.createItemDiagnosticReport(itemId, model)).responseData { dataResponse in
      guard dataResponse.error == nil else {
        switch dataResponse.error! {
        case .sessionTaskFailed(error: URLError.timedOut):
          completion(.failure(.requestTimedOut))
          return
        default:
          break
        }
        completion(.failure(.unknown))
        return
      }

      guard let statusCode = dataResponse.response?.statusCode, statusCode == 201 else {
        completion(.failure(.invalidHttpResponse))
        return
      }
      
      guard let data = dataResponse.value else {
        completion(.failure(.corruptedData))
        return
      }

      do {
        let json = try JSONDecoder().decode(DiagnosticIdModel.self, from: data)
        let diagnosticId = json.id
        var models: [ImageDataModel] = []
        if let data = model.referenceImageData {
          let model = ImageDataModel.init(path: "\(diagnosticId)/images/reference", data: data)
          models.append(model)
        }
        if let data = model.testImageData {
          let model = ImageDataModel.init(path: "\(diagnosticId)/images/test", data: data)
          models.append(model)
        }
        if !models.isEmpty {
          NetworkManager.shared.uploadImages(itemId: itemId, models: models) { result in
            switch result {
            case .success(_):
              completion(.success(()))
            case .failure(let error):
              completion(.failure(error))
            }
          }
        } else {
          completion(.success(())) // no images
        }
      } catch {
        completion(.failure(.decodingError))
      }
    }
  }
  
  func getJSON<T: Codable>(urlRequest: URLRequestConvertible, completion: @escaping (Result<T, NetworkError>) -> Void) {
    AF.request(urlRequest).responseData { dataResponse in
      guard dataResponse.error == nil else {
        switch dataResponse.error! {
        case .sessionTaskFailed(error: URLError.timedOut):
          completion(.failure(.requestTimedOut))
          return
        default:
          break
        }
        completion(.failure(.unknown))
        return
      }
      
      guard let statusCode = dataResponse.response?.statusCode, statusCode > 199, statusCode < 300 else {
        completion(.failure(.invalidHttpResponse))
        return
      }
      
      guard let data = dataResponse.data else {
        completion(.failure(.corruptedData))
        return
      }

      do {
        let json = try JSONDecoder().decode(T.self, from: data)
        completion(.success(json))
      } catch {
        completion(.failure(.decodingError))
      }
    }
  }
  
  func getVoucherbyVoucherCode(_ code: String, completion: @escaping (Result<SensorTestModel, NetworkError>) -> Void) {
    AF.request(NetworkRouter.getVoucherByVoucherCode(code)).responseData { dataResponse in
      guard dataResponse.error == nil else {
        switch dataResponse.error! {
        case .sessionTaskFailed(error: URLError.timedOut):
          completion(.failure(.requestTimedOut))
          return
        default:
          break
        }
        completion(.failure(.unknown))
        return
      }
      
      guard let statusCode = dataResponse.response?.statusCode else {
        completion(.failure(.invalidHttpResponse))
        return
      }
      
      switch statusCode {
      case 403:
        completion(.failure(.codeHasBeenRedeemed))
      case 199 ..< 300:
        break
      default:
        do {
          let json = try JSONSerialization.jsonObject(with: dataResponse.data!, options: .allowFragments)
          Helper.prt(txt: "getVoucherbyVoucherCode json -> \(statusCode)\n\(json)")
        } catch {}
        completion(.failure(.unknown))
      }
      
      guard let data = dataResponse.data else {
        completion(.failure(.corruptedData))
        return
      }

      do {
        let decodedData = try JSONDecoder().decode(DiagnosticRequirements.self, from: data)
        completion(.success(decodedData.requirements.sensorTest))
      } catch {
        completion(.failure(.decodingError))
      }
    }
  }
  
  func surv(surveyVersion: Int) {
    if let _ = UserDefaults.standard.string(forKey: "itemId") {
      
      var params: [String: Any] = ["surveyVersion": surveyVersion]
      
      if let answers = UserDefaults.standard.array(forKey: "SurveyAnswers") as? [[String: Int]] {
        params["answers"] = answers
      }
      
      if let id = UserDefaults.standard.string(forKey: "diagnosticId") {
        params["diagnosticId"] = id
      }
      Helper.prt(txt: "survey params: \(params)")
      
      AF.request(NetworkRouter.surveys(params)).responseJSON { json in

        if let data = json.data {
          do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            Helper.prt(txt: "surv json -> \(json)")
          } catch {}
        }

        print("surv js", json)
        
      }
    }
  }
  
  func offers(completion: @escaping (String) -> Void) {
    
    if Helper.isSSDEnabled() && UserDefaults.standard.bool(forKey: "newOptionsViewSwitch1IsOn") {
      AF.request(NetworkRouter.offers).responseString { res in
  //      print("offers response", res)
        
        UserDefaults.standard.setValue(res.value ?? "", forKey: "OffersHTML")
        
        completion(res.value ?? "")
      }
    }
  }
  
  func rewardScreen(completion: @escaping (String) -> Void) {
    
    if Helper.isSSDEnabled() && UserDefaults.standard.bool(forKey: "newOptionsViewSwitch1IsOn") {
      AF.request(NetworkRouter.rewardScreen).responseString { res in
  //      print("reward screen response", res.request?.url)
        
        UserDefaults.standard.setValue(res.value ?? "", forKey: "RewardScreenHTML")
        
        if let data = res.data {
          do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            Helper.prt(txt: "reward screen json -> \(json)")
          } catch {}
        }
        
        completion(res.value ?? "")
      }
    }
  }
}
