//
//  LocationManager.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-07.
//

import Foundation
import CoreLocation

struct LocationManager {
  static let shared = LocationManager()
  private let manager = CLLocationManager()
  
  private init() {
    manager.requestAlwaysAuthorization()
    manager.allowsBackgroundLocationUpdates = true
    manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    manager.startUpdatingLocation()
    manager.startMonitoringSignificantLocationChanges()
  }
  
  var coordinate: CLLocationCoordinate2D? {
    return manager.location?.coordinate
  }
  
  static var isAuthorizated: Bool {
    return CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedAlways
  }
}
