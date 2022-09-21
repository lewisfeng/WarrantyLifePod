//
//  ImageUploder.swift
//  DDT
//
//  Created by YI BIN FENG on 2022-02-11.
//  Copyright © 2022 Warranty Life. All rights reserved.
//

import Foundation
import Alamofire

extension NetworkManager {
  
  func uploadImages(itemId: String, models: [ImageDataModel], completion: @escaping (Result<Bool, NetworkError>) -> Void) {
    var uploadedCount = 0
    
    for model in models {
      let urlRequest = NetworkRouter.uploadImage(itemId, model.path, model.data)
      AF.upload(multipartFormData: urlRequest.multipartFormData, with: urlRequest).responseData { dataResponse in
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
        
        do {
          let json = try JSONSerialization.jsonObject(with: dataResponse.data!, options: .allowFragments)
          print("upload image json -> \(json)")
        } catch {
          
        }
        
        uploadedCount += 1
        if uploadedCount == models.count {
          
          print("\n\nall photos are uploaded!!!\n\n")
          self.removeReferenceImageAndTestImage()
          
          completion(.success(true))
        }
      }
    }
  }
  
  private func removeReferenceImageAndTestImage() {
    UserDefaults.standard.removeObject(forKey: "ReferenceImage")
    UserDefaults.standard.removeObject(forKey: "TestImage")
  }
}
