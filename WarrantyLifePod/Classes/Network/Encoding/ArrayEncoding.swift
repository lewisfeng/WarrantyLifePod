//
//  ArrayEncoding.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-07.
//

import Foundation
import Alamofire
import Gzip

private let arrayParametersKey = "arrayParametersKey"

/// Extenstion that allows an array be sent as a request parameters
extension Array {
  /// Convert the receiver array to a `Parameters` object.
  func asParameters() -> Parameters {
    return [arrayParametersKey: self]
  }
}

/// Convert the parameters into a json array, and it is added as the request body.
/// The array must be sent as parameters using its `asParameters` method.
public struct ArrayEncoding: ParameterEncoding {
  
  public static var `default`: ArrayEncoding { return ArrayEncoding() }
  
  /// The options for writing the parameters as JSON data.
  public let options: JSONSerialization.WritingOptions
  
  
  /// Creates a new instance of the encoding using the given options
  ///
  /// - parameter options: The options used to encode the json. Default is `[]`
  ///
  /// - returns: The new instance
  public init(options: JSONSerialization.WritingOptions = []) {
    self.options = options
  }
  
  public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
    var urlRequest = try urlRequest.asURLRequest()
    
    guard let parameters = parameters,
      let array = parameters[arrayParametersKey] else {
        return urlRequest
    }
    
    do {
      let data = try JSONSerialization.data(withJSONObject: array, options: options)
      
      urlRequest.setValue("gzip", forHTTPHeaderField: "Content-Encoding")
      urlRequest.allHTTPHeaderFields?.removeValue(forKey: "Content-Type")

      urlRequest.httpBody = try data.gzipped()
      
    } catch {
      throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
    }
    
    return urlRequest
  }
}
