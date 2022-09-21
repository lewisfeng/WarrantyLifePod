//
//  SensorTestDataCollecter.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-02.
//

import Foundation
import CoreMotion

/*
 data struct
 
 "readingAt": "2019-04-01 23:59:59",
 "relativeAltitude": 0.123456789,
 "pressure": 0.123456789,
 "accelerationX": 0.123456789,
 "accelerationY": 0.123456789,
 "accelerationZ": 0.123456789,
 "gyroscopeX": 0.123456789,
 "gyroscopeY": 0.123456789,
 "gyroscopeZ": 0.123456789,
 "magnetometerX": 0.123456789,
 "magnetometerY": 0.123456789,
 "magnetometerZ": 0.123456789,
 "pitch": 0.123456789,
 "roll": 0.123456789,
 "yaw": 0.123456789,
 "soundClipOffsetMs": Int, // in milliseconds
 "phase": Int, // phase id
 "subphase": phase frequency
*/

extension SensorTestViewController {
  func giveMeTheData(deviceMotion: CMDeviceMotion) {
    let model = DeviceMotionDataModel(deviceMotion: deviceMotion, altitudeData: altitudeData, phaseId: sensorTestModel.sensorTestPhases[currentSensorTestPhaseOrder!].phase, toneFrequency: toneOutputUnit.f0, currentRecordingTime: AudioManager.shared.audioRecorder!.currentTime)
    
    models.append(model)
  }
}
