//
//  LoginManager.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-03.
//

import Foundation
import Alamofire

// Login

extension NetworkManager {
  
  func login(user: LoginUserModel, completion: @escaping (Result<Void, NetworkError>) -> Void) {
    
    AF.request(NetworkRouter.login(user)).response { dataResponse in
      
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
      case 202:
        guard let data = dataResponse.data else {
          completion(.failure(.corruptedData))
          return
        }
        do {
          let decodedData = try JSONDecoder().decode(AccessTokenModel.self, from: data)
          self.saveAccessTokenToHeader(accessToken: decodedData)
          
          self.getItemByDeviceId { result in
            
          }
          
          completion(.success(()))
        } catch {
          completion(.failure(.decodingError))
        }
      case 404:
        completion(.failure(.loginEmailPassMissmatch)) // do not report
      default:
        completion(.failure(.unknown))
      }
    }
  }
  
  private func getItemByDeviceId(completion: @escaping (Result<Bool, NetworkError>) -> Void) {
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    AF.request(NetworkRouter.getItemByDeviceId(deviceId)).responseData { dataResponse in
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
      case 200:
        guard let data = dataResponse.data else {
          completion(.failure(.corruptedData))
          return
        }
        do {
          let decodedData = try JSONDecoder().decode(ItemModel.self, from: data)
          UserDefaults.standard.setValue(decodedData.id, forKey: kItemId)
          completion(.success(true))
        } catch {
          completion(.failure(.decodingError))
        }
        completion(.success(true))
      case 404:
        // 404 item id not found, that means there is either no diagnostic app installed on the device or there is but no item id has been created yet through diagnostic
        self.createItem()
      default:
        // 401 - "This device was originally registered under a different account  (l*****7@*.com).  Please log in with that account and try again.
        completion(.failure(.unknown))
      }
    }
  }
  
  private func createItem() {
    AF.request(NetworkRouter.createItem(CreateItemModel())).responseData { dataResponse in
      // 401 - "This device was originally registered under a different account  (l*****7@*.com).  Please log in with that account and try again.
      
      print(dataResponse.response?.statusCode ?? 0)
    }
  }
  
  private func saveAccessTokenToHeader(accessToken: AccessTokenModel) {
    guard let credentialData = "\(accessToken.identity):\(accessToken.token)".data(using: .utf8) else {
      fatalError("Credential Data Error!!!")
    }

    let httpHeaders = ["Authorization": "Basic \(credentialData.base64EncodedString(options: []))"]
    UserDefaults.standard.setValue(httpHeaders, forKey: kHttpHeaders)
  }
}
