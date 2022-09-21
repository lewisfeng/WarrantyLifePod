//
//  NetworkError.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-01.
//

import Foundation

enum NetworkError: String, Error {
  // common
  case noInternet
  case requestTimedOut
  case invalidURL
  case invalidHttpResponse
  case decodingError
  case corruptedData
  
  
  // login
  case loginEmailPassMissmatch = "loginEmailPassMissmatch"
  
  // getVoucherbyVoucherCode
  case codeHasBeenRedeemed = "Voucher has already been redeemed."
  
  case unknown
}

