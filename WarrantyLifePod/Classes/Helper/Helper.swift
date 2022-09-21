//
//  Helper.swift
//  PhoneDropDemo
//
//  Created by YI BIN FENG on 2019-01-22.
//  Copyright © 2019 WarrantyLife. All rights reserved.
//

import UIKit
import CoreMotion
import UserNotifications
import LocalAuthentication

import ARKit

public typealias MilliSeconds = Int // in milliseconds
public typealias Hertz = Int
public typealias Samples = Int

var surfaceButtonTitle = "Hard Surface"
var caseButtonTitle = "With Case"
let kSFST = "Sensor Test"

let gravity: Double = 9.80665
let GRAVITY_EARTH = 9.80665
let SENSOR_DELAY_MILLIS = 1
var dropJsVersion = "1.0"
var impactThreshold: Double = GRAVITY_EARTH * 2.7
var lowerMotionlessThreshold: Double = 0.58
var miniumPercentageOfFallAcceleration: Double = 0.3
var miniumFallingDuration: Double = 0.1
enum Phase: Int {
  case rest = 50, motion = 200, falling = 400, impact = 1000, landing = 2000, ref1 = 5000, vibe = 5100, HZscale = 5200, ref2 = 5900, reset = 9999, unknown = 0
}

var currentFeq: Double = 0.0
var startTime = Date()
let offlineKey = "OfflineData"

class Helper: NSObject {
  class func hasWarranties() -> Bool {
    return UserDefaults.standard.bool(forKey: "isCovered")
  }
  class func isDemographicsSurveyRequired() -> Bool {
    return UserDefaults.standard.bool(forKey: "NeedToDoSurvey")
  }
  
  class func isSSDEnabled() -> Bool {
    return UserDefaults.standard.bool(forKey: "NeedToDoDrivingSurvey")
  }
  
  class func isSSREnabled() -> Bool {
    return UserDefaults.standard.object(forKey: "SavedDDDOffer") != nil
  }
  
  class func randomString(length: Int = 9) -> String {
    return (0..<length).map { _ in String(Int.random(in: 0...9)) }.joined()
  }
  
  class func boldTitle(att: NSAttributedString, title: String, fontSize: CGFloat) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(attributedString: att)
    let text = att.string
    if let range = text.range(of: title) {
      let attrseee = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: fontSize)]
      attributedString.addAttributes(attrseee, range: text.nsRange(from: range))
      
      let attrseeeC = [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
      attributedString.addAttributes(attrseeeC, range: text.nsRange(from: range))
    }

    return attributedString
  }
  
  class func colorText(_ text: String?, colorString: [String], color: UIColor = .green, bold: Bool = false, fontSize: CGFloat = 15, underline: Bool = false, lineSpacing: Bool = false) -> NSAttributedString {
    if let text = text {
      let attrs = [NSAttributedString.Key.foregroundColor: color == .green ? UIColor.green : color]
      let string = NSMutableAttributedString(string: text)
      for str in colorString {
        for range in text.ranges(of: str) {
          string.addAttributes(attrs, range: text.nsRange(from: range))
          if bold {
            let attrseee = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: fontSize)]
            string.addAttributes(attrseee, range: text.nsRange(from: range))
          }
          if underline {
            let attrseee = [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
            string.addAttributes(attrseee, range: text.nsRange(from: range))
          }
        }
      }
      
      if lineSpacing {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        string.addAttribute(
                    .paragraphStyle,
                    value: paragraphStyle,
                    range: NSRange(location: 0, length: string.length
                ))
      }

      return string
    }
    return NSAttributedString.init(string: "")
  }
  
  class func fileSize(forURL url: Any) -> Double {
    var fileURL: URL?
    var fileSize: Double = 0.0
    if (url is URL) || (url is String) {
      if (url is URL) {
        fileURL = url as? URL
      } else {
        fileURL = URL(fileURLWithPath: url as! String)
      }
      var fileSizeValue = 0.0
      try? fileSizeValue = (fileURL?.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).allValues.first?.value as! Double?)!
      if fileSizeValue > 0.0 {
        fileSize = (Double(fileSizeValue) / (1024 * 1024))
      }
    }
    return fileSize
  }
  class func prt(txt: String) {
    print("\n\n")
    print(txt)
    print("\n\n")
  }
  
  class func getRandomString(length: Int = 5) -> String {
    let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    var randomString = ""
    for _ in 0 ..< length {
      let rand = arc4random_uniform(len)
      var nextChar = letters.character(at: Int(rand))
      randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return randomString
  }
  
  class func hasSeenDiagnosticTestIntroductionScreen() -> Bool {
//    if UserDefaults.standard.bool(forKey: "hasSeenDiagnosticTestIntroductionScreen") {
//      return true
//    }
    return UserDefaults.standard.bool(forKey: "hasSeenDiagnosticTestIntroductionScreen")
  }
  
  class func colorText(_ text: String?, colorString: [String], color: UIColor = .green, bold: Bool = false, fontSize: CGFloat = 15, underline: Bool = false) -> NSAttributedString {
    if let text = text {
      let attrs = [NSAttributedString.Key.foregroundColor: color == .green ? UIColor.green : color]
      let string = NSMutableAttributedString(string: text)
      for str in colorString {
        for range in text.ranges(of: str) {
          string.addAttributes(attrs, range: text.nsRange(from: range))
          if bold {
            let attrseee = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: fontSize)]
            string.addAttributes(attrseee, range: text.nsRange(from: range))
          }
          if underline {
            let attrseee = [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
            string.addAttributes(attrseee, range: text.nsRange(from: range))
          }
        }
      }

      return string
    }
    return NSAttributedString.init(string: "")
  }
  
  class func colorText(_ attributedString: NSAttributedString, colorString: String) -> NSAttributedString {
    let att = NSMutableAttributedString.init(attributedString: attributedString)
    let attrs = [NSAttributedString.Key.foregroundColor: UIColor.green, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
    att.addAttributes(attrs, range: (attributedString.string as NSString).range(of: colorString))
    
    return att
  }
  
  class func durationBetweenTwoTimes(time_0: String, time_1: String) -> TimeInterval {
    if let date_0 = dateFromTimestampeShort(time_0), let date_1 = dateFromTimestampeShort(time_1) {
      return abs(date_1.timeIntervalSince(date_0))
    }
    return 0
  }
  class func dateFromTimestampeShort(_ timestampeShort: String) -> Date? {
    let formatter = DateFormatter.init()
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    formatter.dateFormat = "HH:mm:ss.SSS"
    
    return formatter.date(from: timestampeShort)
  }
  
  class func dateFromString(_ timestampeShort: String) -> Date? {
    let formatter = DateFormatter.init()
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    formatter.dateFormat = "yyyy-MM-dd"
    
    return formatter.date(from: timestampeShort)
  }
  
  class func timestampeShort(date: Date) -> String {
    let formatter = DateFormatter.init()
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    formatter.dateFormat = "HH:mm:ss.SSS"
    
    return formatter.string(from: date)
  }
  
  class func dropTime(date: Date? = nil) -> String {
    let formatter = DateFormatter.init()
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    return formatter.string(from: date ?? Date())
  }
  
  class func dayFromDate(_ date: Date? = nil) -> String {
    let formatter = DateFormatter.init()
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    formatter.dateFormat = "yyyy-MM-dd"
    
    return formatter.string(from: date ?? Date())
  }

  class func getAppState() -> String {
    switch UIApplication.shared.applicationState {
    case .active:
      return "active"
    case .inactive:
      return "inactive"
    case .background:
      return "background"
    @unknown default:
      fatalError()
    }
  }
    
  class func sendNotification(info: [String: String]?) {
    if UIApplication.shared.applicationState != .active {
      let content = UNMutableNotificationContent.init()
      var title = "Drop detected !!!"
      var badgeCount = 1
      if let info = info, let startTime = info["startTime"], let endTime = info["endTime"], let count = info["count"] {
        badgeCount = Int(count)!
        let drops = count == "1" ? "drop" : "drops"
        title = "\(count) recorded \(drops) detected !!!"
        content.subtitle = "\(startTime)  -  \(endTime)"
      }
      content.title = title
      content.body = "Tap here to re-open the app to check more details!"
      let request = UNNotificationRequest.init(identifier: "identifier", content: content, trigger: nil)
      let center = UNUserNotificationCenter.current()
      center.add(request) { error in }
      
      increaseAppIconBadgeCount(badgeCount)
    }
  }
  
  private class func increaseAppIconBadgeCount(_ count: Int) {
    DispatchQueue.main.async {
      UIApplication.shared.applicationIconBadgeNumber += count
    }
    
  }
  
  class func timeIntervalBetween2Times(time_0: String, time_1: String) -> TimeInterval {
    let formatter = DateFormatter.init()
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    
    if let date_0 = formatter.date(from: time_0), let date_1 = formatter.date(from: time_1) {
      return abs(date_0.timeIntervalSince(date_1))
    }
    return 0.0
  }
  
//  class func getTimeStamp(date: Date) -> String {
//    if #available(iOS 11.0, *) {
//      let iso8601DateFormatter = ISO8601DateFormatter()
//      iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//
//      return iso8601DateFormatter.string(from: date)
//    } else {
//      let formatter = DateFormatter()
//      formatter.calendar = Calendar(identifier: .iso8601)
//      formatter.locale = Locale(identifier: "en_US_POSIX")
//      formatter.timeZone = TimeZone(secondsFromGMT: 0)
//      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
//
//      return formatter.string(from: date)
//    }
//  }
  
  class func getTimeStamp(date: Date = Date()) -> String {
    let formatter = DateFormatter.init()
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    
    return formatter.string(from: date)
  }
  
  class func getCurrentTimeStamp() -> String {
    let formatter = DateFormatter.init()
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
    
    return formatter.string(from: Date())
  }
  
  class func getTimeString(date: Date) -> String {
    let formatter = DateFormatter.init()
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    return formatter.string(from: date)
  }
  
  class func getTimeStringShort(date: Date) -> String {
    let formatter = DateFormatter.init()
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    formatter.dateFormat = "HH:mm:ss"
    return formatter.string(from: date)
  }
}
extension String {
  func hasRange(_ range: NSRange) -> Bool {
    return Range(range, in: self) != nil
  }
  
  func utf8EncodedString()-> String {
    let messageData = self.data(using: .nonLossyASCII)
    let text = String(data: messageData!, encoding: .utf8)
    return text ?? "123"
  }
  
  func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
    let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

    return ceil(boundingBox.width)
  }

  func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

    return ceil(boundingBox.height)
  }
}
extension Date {
  func currentTimeMillis() -> Int64! {
    return Int64(self.timeIntervalSince1970 * 1000)
  }
}

class Acceleration{
  
  static func fromAccelerometerData(data:CMAccelerometerData?)->Double{
    
    let x = (data?.acceleration.x)!*10
    let y = (data?.acceleration.y)!*10
    let z = (data?.acceleration.z)!*10
    
    return (x * x + y * y + z * z).squareRoot()
  }
  
  static func fromAccelerometerRecoredData(data:CMAccelerometerData?)->Double{
    
    let x = (data?.acceleration.x)!*10
    let y = (data?.acceleration.y)!*10
    let z = (data?.acceleration.z)!*10
    
    return (x * x + y * y + z * z).squareRoot()
  }
  
  static func fromAccelerometerData(data:CMAcceleration?)->Double{
    
    let x = (data?.x)!*10
    let y = (data?.y)!*10
    let z = (data?.z)!*10
    
    return (x * x + y * y + z * z).squareRoot()
  }
  
  static func calculateAcceleration(x: Double, y: Double, z: Double) -> Double {
    return (x * x * 100 + y * y * 100 + z * z * 100).squareRoot()
  }
}

extension String {
    func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while ranges.last.map({ $0.upperBound < self.endIndex }) ?? true,
            let range = self.range(of: substring, options: options, range: (ranges.last?.upperBound ?? self.startIndex)..<self.endIndex, locale: locale)
        {
            ranges.append(range)
        }
        return ranges
    }
  
  func nsRange(from range: Range<String.Index>) -> NSRange {
      let from = range.lowerBound.samePosition(in: utf16)
      let to = range.upperBound.samePosition(in: utf16)
    return NSRange(location: utf16.distance(from: utf16.startIndex, to: from!),
                   length: utf16.distance(from: from!, to: to!))
  }
}
public extension Double {
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }

    /// Random double between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random double point number between 0 and n max
  static func random(min: Double = 0.111, max: Double = 0.777) -> Double {
    #if DEBUG
    return (Double.random * (max - min) + min) / 3 // I want 3 times faster for debug
    #else
    return Double.random * (max - min) + min
    #endif
        
    }
}

extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
}
public enum Model : String {

//Simulator
case simulator     = "simulator/sandbox",

//iPod
iPod1              = "iPod 1",
iPod2              = "iPod 2",
iPod3              = "iPod 3",
iPod4              = "iPod 4",
iPod5              = "iPod 5",

//iPad
iPad2              = "iPad 2",
iPad3              = "iPad 3",
iPad4              = "iPad 4",
iPadAir            = "iPad Air ",
iPadAir2           = "iPad Air 2",
iPadAir3           = "iPad Air 3",
iPadAir4           = "iPad Air 4",
iPad5              = "iPad 5", //iPad 2017
iPad6              = "iPad 6", //iPad 2018
iPad7              = "iPad 7", //iPad 2019
iPad8              = "iPad 8", //iPad 2020

//iPad Mini
iPadMini           = "iPad Mini",
iPadMini2          = "iPad Mini 2",
iPadMini3          = "iPad Mini 3",
iPadMini4          = "iPad Mini 4",
iPadMini5          = "iPad Mini 5",

//iPad Pro
iPadPro9_7         = "iPad Pro 9.7\"",
iPadPro10_5        = "iPad Pro 10.5\"",
iPadPro11          = "iPad Pro 11\"",
iPadPro2_11        = "iPad Pro 11\" 2nd gen",
iPadPro12_9        = "iPad Pro 12.9\"",
iPadPro2_12_9      = "iPad Pro 2 12.9\"",
iPadPro3_12_9      = "iPad Pro 3 12.9\"",
iPadPro4_12_9      = "iPad Pro 4 12.9\"",

//iPhone
iPhone4            = "iPhone 4",
iPhone4S           = "iPhone 4S",
iPhone5            = "iPhone 5",
iPhone5S           = "iPhone 5S",
iPhone5C           = "iPhone 5C",
iPhone6            = "iPhone 6",
iPhone6Plus        = "iPhone 6 Plus",
iPhone6S           = "iPhone 6S",
iPhone6SPlus       = "iPhone 6S Plus",
iPhoneSE           = "iPhone SE",
iPhone7            = "iPhone 7",
iPhone7Plus        = "iPhone 7 Plus",
iPhone8            = "iPhone 8",
iPhone8Plus        = "iPhone 8 Plus",
iPhoneX            = "iPhone X",
iPhoneXS           = "iPhone XS",
iPhoneXSMax        = "iPhone XS Max",
iPhoneXR           = "iPhone XR",
iPhone11           = "iPhone 11",
iPhone11Pro        = "iPhone 11 Pro",
iPhone11ProMax     = "iPhone 11 Pro Max",
iPhoneSE2          = "iPhone SE 2nd gen",
iPhone12Mini       = "iPhone 12 Mini",
iPhone12           = "iPhone 12",
iPhone12Pro        = "iPhone 12 Pro",
iPhone12ProMax     = "iPhone 12 Pro Max",

//Apple TV
AppleTV            = "Apple TV",
AppleTV_4K         = "Apple TV 4K",
unrecognized       = "?unrecognized?"
}

// #-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: UIDevice extensions
// #-#-#-#-#-#-#-#-#-#-#-#-#

public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                       return "iPod touch (5th generation)"
            case "iPod7,1":                                       return "iPod touch (6th generation)"
            case "iPod9,1":                                       return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":           return "iPhone 4"
            case "iPhone4,1":                                     return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                        return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                        return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                        return "iPhone 5s"
            case "iPhone7,2":                                     return "iPhone 6"
            case "iPhone7,1":                                     return "iPhone 6 Plus"
            case "iPhone8,1":                                     return "iPhone 6s"
            case "iPhone8,2":                                     return "iPhone 6s Plus"
            case "iPhone8,4":                                     return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                        return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                        return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                      return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                      return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                      return "iPhone X"
            case "iPhone11,2":                                    return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                      return "iPhone XS Max"
            case "iPhone11,8":                                    return "iPhone XR"
            case "iPhone12,1":                                    return "iPhone 11"
            case "iPhone12,3":                                    return "iPhone 11 Pro"
            case "iPhone12,5":                                    return "iPhone 11 Pro Max"
            case "iPhone12,8":                                    return "iPhone SE (2nd generation)"
            case "iPhone13,1":                                    return "iPhone 12 mini"
            case "iPhone13,2":                                    return "iPhone 12"
            case "iPhone13,3":                                    return "iPhone 12 Pro"
            case "iPhone13,4":                                    return "iPhone 12 Pro Max"
            case "iPhone14,4":                                    return "iPhone 13 mini"
            case "iPhone14,5":                                    return "iPhone 13"
            case "iPhone14,2":                                    return "iPhone 13 Pro"
            case "iPhone14,3":                                    return "iPhone 13 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":      return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":                 return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":                 return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                          return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                            return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                          return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                          return "iPad (8th generation)"
            case "iPad12,1", "iPad12,2":                          return "iPad (9th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":                 return "iPad Air"
            case "iPad5,3", "iPad5,4":                            return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                          return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                          return "iPad Air (4th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":                 return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":                 return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":                 return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                            return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                          return "iPad mini (5th generation)"
            case "iPad14,1", "iPad14,2":                          return "iPad mini (6th generation)"
            case "iPad6,3", "iPad6,4":                            return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                            return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":      return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                           return "iPad Pro (11-inch) (2nd generation)"
            case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return "iPad Pro (11-inch) (3rd generation)"
            case "iPad6,7", "iPad6,8":                            return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                            return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":      return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                          return "iPad Pro (12.9-inch) (4th generation)"
            case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":return "iPad Pro (12.9-inch) (5th generation)"
            case "AppleTV5,3":                                    return "Apple TV"
            case "AppleTV6,2":                                    return "Apple TV 4K"
            case "AudioAccessory1,1":                             return "HomePod"
            case "AudioAccessory5,1":                             return "HomePod mini"
            case "i386", "x86_64", "arm64":                                return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                              return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}

enum BiometricType{
    case touch
    case face
    case none
}
extension UIViewController {
  func hideBackgroundImageView() {
    for item in view.subviews {
      if item is UIImageView {
        if let image = (item as! UIImageView).image {
          if image.size.width == 576 && image.size.height == 1024 {
            item.isHidden = true
            view.backgroundColor = .white
            break
          }
        }
      }
    }
  }
}

extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}
extension TimeInterval{

  func stringFromTimeInterval() -> String {

      let time = NSInteger(self)

      let seconds = time % 60
      let minutes = (time / 60) % 60
      let hours = (time / 3600) % 24

      var formatString = ""
      if hours == 0 {
          if(minutes < 10) {
              formatString = "%2d:%0.2d"
          }else {
              formatString = "%0.2d:%0.2d"
          }
          return String(format: formatString,minutes,seconds)
      }else {
          formatString = "%2d:%0.2d:%0.2d"
          return String(format: formatString,hours,minutes,seconds)
      }
  }
  
  func timeIntervalAsString(_ format : String = "dd,hh,mm,ss") -> String {
          var asInt   = NSInteger(self)
          let ago = (asInt < 0)
          if (ago) {
              asInt = -asInt
          }
          let ms = Int(self.truncatingRemainder(dividingBy: 1) * (ago ? -1000 : 1000))
          let s = asInt % 60
          let m = (asInt / 60) % 60
          let h = ((asInt / 3600))%24
          let d = (asInt / 86400)

          var value = format
          value = value.replacingOccurrences(of: "hh", with: String(format: "%0.2d", h))
          value = value.replacingOccurrences(of: "mm",  with: String(format: "%0.2d", m))
          value = value.replacingOccurrences(of: "sss", with: String(format: "%0.3d", ms))
          value = value.replacingOccurrences(of: "ss",  with: String(format: "%0.2d", s))
          value = value.replacingOccurrences(of: "dd",  with: String(format: "%d", d))
          if (ago) {
              value += " ago"
          }
          return value
      }

}

extension CharacterSet {
    
    /// Characters valid in part of a URL.
    ///
    /// This set is useful for checking for Unicode characters that need to be percent encoded before performing a validity check on individual URL components.
    static var urlAllowedCharacters: CharacterSet {
        // You can extend any character set you want
        var characters = CharacterSet.urlQueryAllowed
        characters.subtract(CharacterSet(charactersIn: "+"))
        return characters
    }
}

extension UIDevice {

  func getTotalDiskSpaceInGB() -> String? {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    do {
      let dictionary = try FileManager.default.attributesOfFileSystem(forPath: paths.last!)
      let totalSize = dictionary[FileAttributeKey.systemSize] as! Int64
      return gbFormatter(totalSize)
    } catch let error {
      return nil
    }
  }
  
  var totalDiskSpaceInGB: String {
    return totalDiskSpaceInBytes == 0 ? "" : gbFormatter(totalDiskSpaceInBytes)
  }

  var usedDiskSpaceInGB: String {
    return (totalDiskSpaceInBytes == 0 || freeDiskSpaceInBytes == 0) ? "" : gbFormatter(totalDiskSpaceInBytes - freeDiskSpaceInBytes)
  }

  
  //MARK: Get raw value
  var totalDiskSpaceInBytes: Int64 {
    guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String), let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else {
      return 0
    }
    return space
  }

  var freeDiskSpaceInBytes: Int64 {
    if #available(iOS 11.0, *) {
      if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
        return space ?? 0
      } else {
        return 0
      }
    } else {
      if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
        let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value {
        return freeSpace
      } else {
        return 0
      }
    }
  }
  
  func gbFormatter(_ bytes: Int64) -> String {
    let formatter = ByteCountFormatter()
    formatter.allowedUnits = ByteCountFormatter.Units.useGB
    formatter.countStyle = ByteCountFormatter.CountStyle.decimal
    formatter.includesUnit = false
    return "\(formatter.string(fromByteCount: bytes) as String) GB"
  }
}

extension UIColor {
    public convenience init?(hex: String) {
      var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

      if (cString.hasPrefix("#")) {
          cString.remove(at: cString.startIndex)
      }

      if ((cString.count) != 6) {
          return nil
      }

      var rgbValue:UInt64 = 0
      Scanner(string: cString).scanHexInt64(&rgbValue)
      
      self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
}

extension UIColor {
  class func c_2b2b2b() -> UIColor{
    return UIColor.init(hex: "2B2B2B")!
  }
  class func c_009966() -> UIColor{
    return UIColor.init(hex: "009966")!
  }
}
