//
//  NetworkHelper.swift
//  WarrantyLifePod
//
//  Created by YI BIN FENG on 2022-09-21.
//

import Foundation

public final class NetworkHelper {
  
  class func randomString(length: Int = 9) -> String {
    return (0..<length).map { _ in String(Int.random(in: 0...9)) }.joined()
  }
  
  class func getTimeStamp(date: Date = Date()) -> String {
    let formatter = DateFormatter.init()
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    
    return formatter.string(from: date)
  }
}
