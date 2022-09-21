//
//  UploadSensorTestManager.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-06.
//

import Foundation
import Alamofire

// Upload sensor test

extension NetworkManager {
  
  func uploadSensorEventData(itemId: String, apiDataModel: SensorEventAPIDataModel, completion: @escaping (Result<Void, NetworkError>) -> Void) {
    
    guard NetworkReachabilityManager()!.isReachable else {
      completion(.failure(.noInternet))
      return
    }
    
    // event
    sensorEvent(itemId: itemId, apiDataModel: apiDataModel) { [weak self] result in
      switch result {
      case .success(let sensorEventId):
        
        // readings
        self?.sensorReadings(itemId: itemId, sensorEventId: sensorEventId, readings: apiDataModel.readings, completion: { [weak self] result in
          
          switch result {
          case .success:
            
            // audio
            self?.audio(itemId: itemId, sensorEventId: sensorEventId, createdAt: apiDataModel.event.eventAt, url: apiDataModel.audio, completion: { [weak self] result in
              guard self != nil else { return }
              
              switch result {
              case .success():
                completion(.success(()))
              case .failure(let error):
                completion(.failure(error))
              }
            })
          case .failure(let error):
            completion(.failure(error))
          }
        })
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  private func sensorEvent(itemId: String, apiDataModel: SensorEventAPIDataModel, completion: @escaping (Result<String, NetworkError>) -> Void) {
    AF.request(NetworkRouter.sensorEvent(itemId, apiDataModel)).responseData { dataResponse in
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
      
      guard let statusCode = dataResponse.response?.statusCode, statusCode == 202 else {
        
        if let d = dataResponse.data {
          do {
            let json = try JSONSerialization.jsonObject(with: d, options: .allowFragments)
            Helper.prt(txt: "sensorEvent api call data json -> \(json)")
          } catch {}
        }

        completion(.failure(.invalidHttpResponse))
        return
      }

      guard let data = dataResponse.data else {
        completion(.failure(.corruptedData))
        return
      }
      
      // FIXME:
//      DropSwitch.shared.updateHeartbeatIntervalAndDuration(data)
      
      do {
        let decodedData = try JSONDecoder().decode(SensorEventIdModel.self, from: data)
        completion(.success(decodedData.sensorEventId))
      } catch {
        completion(.failure(.decodingError))
      }
    }
  }
  
  //
  // MARK: - Readings
  
  private func sensorReadings(itemId: String, sensorEventId: String, readings: [DeviceMotionDataModel], completion: @escaping (Result<Void, NetworkError>) -> Void) {
    AF.request(NetworkRouter.sensorReadings(itemId, sensorEventId, readings)).responseData { dataResponse in
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
      completion(.success(()))
    }
  }
  
  //
  // MARK: - Audio
  
  private func audio(itemId: String, sensorEventId: String, createdAt: String, url: URL?, completion: @escaping (Result<Void, NetworkError>) -> Void) {
    guard let url = url, Helper.fileSize(forURL: url) > 0 else {
      completion(.success(()))
      return
    }
    
    #if DEBUG
    print(url.absoluteString)
    Helper.prt(txt: "send sensor test audio size: \(Helper.fileSize(forURL: url))")
    #endif

    AF.upload(url, with: NetworkRouter.sensorAudio(itemId, sensorEventId, createdAt)).responseData { dataResponse in
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

      Helper.prt(txt: "send sensor test audio: \(dataResponse.response?.statusCode ?? 0)")
      
      guard let statusCode = dataResponse.response?.statusCode, statusCode == 201 else {
        completion(.failure(.invalidHttpResponse))
        return
      }
      
      completion(.success(()))
    }
  }
}

