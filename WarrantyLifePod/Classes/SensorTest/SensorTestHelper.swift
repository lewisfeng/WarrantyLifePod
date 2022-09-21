//
//  SensorTestHelper.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-07.
//

import Foundation

//
// MARK: - Helper methods

extension SensorTestViewController {
  func isTestRunning() -> Bool {
    return currentSensorTestPhaseOrder != nil || isTakingPhoto
  }
  
  func playRecordedAudio() {
    AudioManager.shared.playAudio(url: nil)
  }
  
  func printTimeSpent() {
    let totalSpentTestDuration = Date().timeIntervalSince(startTime)
    // note: we can use the duration for vibe phase returned from server, because in iOS you can not set duration for vibration, each vibration is around  0.575 seconds, the way to calculate the total test duration is to check how many vibe phases in the test, then minus the returned duration then multip by 0.575
    let sensorTestPhasesRemovedVibe = sensorTestModel.sensorTestPhases.filter({$0.phase != 5100})
    let vibeCount = sensorTestModel.sensorTestPhases.count - sensorTestPhasesRemovedVibe.count
    let totalTestDuration = sensorTestPhasesRemovedVibe.map({ $0.durationMs / 1000 }).reduce(0, +) + Double(vibeCount) * vibratinDuration
    print("total test duration -> \(totalTestDuration), total sepnt -> \(String(format: "%.2f", totalSpentTestDuration)), recorded audio druation -> \(String(format: "%.2f", recordedAudioLength))")
    
    if abs(recordedAudioLength - totalSpentTestDuration) > 1.5 {
      Logger.logFatalError(title: "Total sensor test duration not match !!!")
    }
  }
}
