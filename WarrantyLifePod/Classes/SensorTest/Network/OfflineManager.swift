//
//  OfflineManager.swift
//  DDT
//
//  Created by YI BIN FENG on 2022-02-23.
//  Copyright © 2022 Warranty Life. All rights reserved.
//

import Foundation

class OfflineManager {
  static let shared = OfflineManager()
  private var isSendingData = false
  private var timer: Timer?
  private var lastCallDate = Date()
  private var models: [SensorEventAPIDataModel] = []
  private let intervalGap: TimeInterval = 3.0
  private let gapBetweenEachCall: TimeInterval = 15.0
  
  private init() {
    getModels()
    startTimer()
  }
  
  // append new model
  func appendModel(_ model: SensorEventAPIDataModel) {
    models.append(model)
    models = models.sorted(by: {$0.retryDate < $1.retryDate})

    Helper.prt(txt: "offline manager models: \(models.count)")
    
    startTimer()
  }
  
  // save models to userdefault when applicationWillTerminate is called
  func saveModels() {
    var array: [Data] = []
    for model in models {
      do {
        let encoded = try JSONEncoder().encode(model)
        array.append(encoded)
      } catch {
        Logger.logFatalError(title: #function, error)
      }
    }
    UserDefaults.standard.setValue(array, forKey: kSensorData)
    UserDefaults.standard.synchronize()
  }
  
  // get models from userdefault, this only get called once
  private func getModels() {
//    #if DEBUG
//    UserDefaults.standard.removeObject(forKey: kSensorData)
//    #endif
    if let savedSensorEventAPIDataModels = UserDefaults.standard.array(forKey: kSensorData) as? [Data] {
      for item in savedSensorEventAPIDataModels {
        do {
          let decodedData = try JSONDecoder().decode(SensorEventAPIDataModel.self, from: item)
          models.append(decodedData)
        } catch {
          Logger.logFatalError(title: #function, error)
        }
      }
      models = models.sorted(by: {$0.retryDate < $1.retryDate})
    }
    
    Helper.prt(txt: "offline manager models: \(models.count)")
  }
  
  private func startTimer() {
    guard !models.isEmpty && timer == nil else { return }
    
    Helper.prt(txt: "offline manager start timer")
    
    timer = Timer.scheduledTimer(withTimeInterval: intervalGap, repeats: true) { _ in
      if !self.isSendingData && Date() > self.lastCallDate + self.gapBetweenEachCall {
        self.check()
      }
    }
  }
  
  private func check() {
    guard let model = models.first,
          let itemId = UserDefaults.standard.string(forKey: "itemId")
    else {
      Helper.prt(txt: "offline manager all models were sent!!!")
      UserDefaults.standard.removeObject(forKey: kSensorData)
      timer?.invalidate()
      timer = nil
      return
    }
    
    guard model.retryDate < Date() else { return }
    
    sendData(model, itemId)
  }
  
  private func sendData(_ apiDataModel: SensorEventAPIDataModel, _ itemId: String) {
    isSendingData = true
    models.removeFirst()

    NetworkManager.shared.uploadSensorEventData(itemId: itemId, apiDataModel: apiDataModel) { result in
      self.isSendingData = false
      self.lastCallDate = Date()

      switch result {
      case .success():
        Helper.prt(txt: "offline manager upload succeed!!!")
        break
      case .failure(let error):
        Helper.prt(txt: "offline manager upload failed: \(error.localizedDescription)")
        self.sendDataFailed(model: apiDataModel)
      }
    }
  }
  
  private func sendDataFailed(model: SensorEventAPIDataModel) {
    if model.retryCount < 4 {
      var model = model
      model.retryCount += 1
      
      switch model.retryCount {
      case 1:
        model.retryDate = Date() + 10 // (60 * 5) // 5 mins
      case 2:
        model.retryDate = Date() + 15 // (60 * 60) // 1 hour
      case 3:
        model.retryDate = Date() + 30 // (60 * 60 * 8) // 8 hours
      case 4:
        model.retryDate = Date() + 60 // (60 * 60 * 24) // 24 hours
      default:
        break
      }
      appendModel(model)
    }
  }
}
