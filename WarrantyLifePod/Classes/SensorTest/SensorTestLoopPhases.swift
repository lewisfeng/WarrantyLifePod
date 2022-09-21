//
//  SensorTestLoopPhases.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-01.
//

import Foundation
import AudioUnit

extension SensorTestViewController {
  func loopSensorTestModelPhases() {
    guard let order = currentSensorTestPhaseOrder else {
      // device movement detected during testing, test stopped 
      return
    }
    if order == sensorTestModel.sensorTestPhases.count - 1 { // end of the phases
      loopSensorTestModelPhasesFinished()
      return
    }

    currentSensorTestPhaseOrder! += 1
    
    var currentSensorTestPhase = sensorTestModel.sensorTestPhases[currentSensorTestPhaseOrder!]
    
    switch currentSensorTestPhase.phaseId {
    case .rest, .ref1, .ref2:
      phase_rest(durationS: currentSensorTestPhase.durationS)
    case .vibe:
      phase_vibe()
    case .HZscale:
      phase_HZscale(phase: &currentSensorTestPhase)
    default:
      Logger.logFatalError(title: "\(#function) -> phaseId == nil OR unknown")
      break
    }
  }
  
  private func phase_rest(durationS: Double) {
    DispatchQueue.main.asyncAfter(deadline: .now() + durationS) {
      self.showCompletedPercentage()
      self.loopSensorTestModelPhases()
    }
  }
  
  private func phase_vibe() {
    if runCaseDetectionOnDrop {
      AudioServicesPlayAlertSound(1352)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        self.loopSensorTestModelPhasesFinished()
      }
    } else {
      AudioServicesPlayAlertSoundWithCompletion(1352) {
        self.showCompletedPercentage()
        self.loopSensorTestModelPhases()
      }
    }
  }
  
  private func phase_HZscale(phase: inout SensorTestPhase) {
    guard let startFreq = phase.startFreq, let endFreq = phase.endFreq, let stepFreq = phase.stepFreq else {
      Logger.logFatalError(title: "\(#function) \(String(describing: phase))")
      return
    }
    let durationS = phase.durationS
    let timeInterval = durationS / (abs(endFreq - startFreq) / stepFreq + 1)
    toneOutputUnit.setFrequency(freq: startFreq)
    toneOutputUnit.setToneTime(t: timeInterval)
    
    DispatchQueue.main.async {
      self.toneOutputUnitTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { timer in
        self.showCompletedPercentage()
        
        let currentFreq = self.toneOutputUnit.f0
        let nextFreq = currentFreq + stepFreq
        if nextFreq > endFreq {
          self.toneOutputUnit.setFrequency(freq: -1.0)
          self.toneOutputUnitTimer?.invalidate()
          self.toneOutputUnitTimer = nil
          
          self.loopSensorTestModelPhases()
        } else {
          self.toneOutputUnit.setFrequency(freq: nextFreq)
          self.toneOutputUnit.setToneTime(t: timeInterval)
        }
      })
    }
  }
}
