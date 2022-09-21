//
//  SensorTestSelectors.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-08.
//

import Foundation
import UIKit

extension SensorTestViewController {
  
  @objc func backButtonClicked() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc func menuButtonClicked() {
    navigationController?.popToRootViewController(animated: true)
  }
  
  
  @objc func waveformImageViewClicked() {
    prepareForTheTest()
    
    DispatchQueue.main.async {
      self.waveformImageView.isUserInteractionEnabled = false
      self.startButton.isHidden = true
      self.updateCountDownText(seconds: 3)
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        self.updateCountDownText(seconds: 2)
        // I set it ture here is because it needs 1.8 second to check if the device is stable and horizontal
        self.userStartsTest = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
          self.updateCountDownText(seconds: 1)
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.centerLabel.text = ""
            
            self.checkIfTestStarted()
          }
        }
      }
    }
  }
  
  @objc func nextButtonClicked() {

    // FIXME:
    
  }
  
  private func updateCountDownText(seconds: Int) {
    if isFaceDown {
      self.topLabel.attributedText = Helper.colorText("Put Device Face Down to Start\n\nTest is finished when you hear the BING!", colorString: ["Put Device Face Down to Start"], color: UIColor.c_009966(), bold: true, fontSize: 17, underline: true)
    } else {
      self.topLabel.text = "Despite the temptation, please leave the device still while the test is in progress.\n\nYou can do it. 😄"
    }
    let text = "Test will start in\n\n\(seconds)"
    self.centerLabel.attributedText = Helper.colorText(text, colorString: ["\(seconds)"], bold: true)
  }
  
  // after count down to 0 if test is not started that means device is not stable or not horizontal, then we need to show message
  private func checkIfTestStarted() {
    if !isTestRunning() {
      if runCaseDetectionOnDrop {
        DispatchQueue.main.async {
          self.dismiss(animated: false, completion: nil)
        }
      } else {
        DispatchQueue.main.async {
          var text = "First, the device needs to be on a flat surface to continue."
          if self.isFaceDown {
            text = "First, the device needs to  be on a flat surface and face down to continue."
          }
          self.centerLabel.attributedText = Helper.colorText(text, colorString: ["flat", "face down"], color: .systemRed, bold: true, fontSize: 19)
        }
      }
    }
  }
  
  func showDeviceMovementDetectedDuringTestPopup() {
    DispatchQueue.main.async {
      let alertController = UIAlertController(title: "Oops!", message: "The test was interrupted because some movement was detected, and needs to restart. Please place this device on a flat, level surface facing downwards and leave it there for a few seconds until this test is complete. Thanks", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "I'm Ready!", style: .default, handler: { _ in
        self.waveformImageViewClicked()
      }))
      self.present(alertController, animated: true, completion: nil)
    }
  }
  
  func showCompletedPercentage() {
    updateDebugWindowInfo()
    DispatchQueue.main.async {
      let testPassedDurtion = Date().timeIntervalSince(self.startTime)
      let percentComplete = Int((testPassedDurtion / self.totalTestDuration) * 100)
      let text = "Testing In Progress\n\n\(percentComplete)%"
      self.centerLabel.attributedText = Helper.colorText(text, colorString: ["\(percentComplete)%"], bold: true)
    }
  }
  
  // ddt or debug use only
  func updateDebugWindowInfo() {
    #if DEBUG
    let line_0 = self.sensorTestModel.name
    let line_1 = ""
    
    var phaseName = "null"
    var line_2 = "phase: \(phaseName)" // line 0 uses to descripe phases
    if let currentOrder = self.currentSensorTestPhaseOrder {
      var currentPhase = self.sensorTestModel.sensorTestPhases[currentOrder]
      phaseName = String(describing: currentPhase.phaseId)
      line_2 = "phase: .\(phaseName)"
      if currentPhase.phaseId == .HZscale {
        line_2 = "phase: .\(phaseName) ~ freq: \(self.toneOutputUnit.f0)"
      }
    }
    let runs = self.numberOfRuns > 0 ? self.numberOfRuns : 0
    let line_3 = "remining: \(runs) ~ succeed: \(self.apiPassedCount) ~ failed: \(self.apiFailedCount)"
    
    var realTestDur = "\(String(format: "%.2f", Date().timeIntervalSince(self.startTime)))"
    var audioLength = "\(String(format: "%.2f", AudioManager.shared.audioRecorder?.currentTime ?? 0.0))"
    if AudioManager.shared.audioRecorder?.currentTime == 0.0 {
      realTestDur = self.realTestDur
      audioLength = self.audioLength
    }
    self.realTestDur = realTestDur
    self.audioLength = audioLength

    let line_4 = "test dur: \(realTestDur) ~ audio dur: \(audioLength)"
    let line_5 = "sensor reading: \(models.count)"

    let text = "\(line_0)\n\(line_1)\n\(line_2)\n\(line_3)\n\(line_4)\n\(line_5)"
    let attributedText = Helper.colorText(text, colorString: [phaseName, "\(self.toneOutputUnit.f0)", "\(runs)", "\(self.apiPassedCount)", "\(self.apiFailedCount)", realTestDur, audioLength, "\(models.count)"], color: .systemRed, bold: true, fontSize: 15, lineSpacing: true)
    DispatchQueue.main.async {
      self.bottomLabel.attributedText = Helper.boldTitle(att: attributedText, title: line_0, fontSize: 13.3)
    }
    #endif
  }
  
  func showFinishedTestAnimation() {
    let text_0 = "Testing Done - 100%\n\nAccelerometer:"
    let text_1 = "Testing Done - 100%\n\nAccelerometer: OK"
    let text_2 = "Testing Done - 100%\n\nAccelerometer: OK\n\nGyroscope:"
    let text_3 = "Testing Done - 100%\n\nAccelerometer: OK\n\nGyroscope: OK"
    let text_4 = "Testing Done - 100%\n\nAccelerometer: OK\n\nGyroscope: OK\n\nMagnetometer:"
    let text_5 = "Testing Done - 100%\n\nAccelerometer: OK\n\nGyroscope: OK\n\nMagnetometer: OK"
    let text_6 = "Testing Done - 100%\n\nAccelerometer: OK\n\nGyroscope: OK\n\nMagnetometer: OK\n\nMicrophone:"
    let text_7 = "Testing Done - 100%\n\nAccelerometer: OK\n\nGyroscope: OK\n\nMagnetometer: OK\n\nMicrophone: OK"
    let text_8 = "Testing Done - 100%\n\nAccelerometer: OK\n\nGyroscope: OK\n\nMagnetometer: OK\n\nMicrophone: OK\n\nSpeaker:"
    let text_9 = "Testing Done - 100%\n\nAccelerometer: OK\n\nGyroscope: OK\n\nMagnetometer: OK\n\nMicrophone: OK\n\nSpeaker: OK"
    let text_10 = "Testing Done - 100%\n\nAccelerometer: OK\n\nGyroscope: OK\n\nMagnetometer: OK\n\nMicrophone: OK\n\nSpeaker: OK\n\nFrequency Response:"
    let text_11 = "Testing Done - 100%\n\nAccelerometer: OK\n\nGyroscope: OK\n\nMagnetometer: OK\n\nMicrophone: OK\n\nSpeaker: OK\n\nFrequency Response: OK"
    let text_12 = "Testing Done - 100%\n\nAccelerometer: OK\n\nGyroscope: OK\n\nMagnetometer: OK\n\nMicrophone: OK\n\nSpeaker: OK\n\nFrequency Response: OK\n\nVibration Motor:"
    let text_13 = "Testing Done - 100%\n\nAccelerometer: OK\n\nGyroscope: OK\n\nMagnetometer: OK\n\nMicrophone: OK\n\nSpeaker: OK\n\nFrequency Response: OK\n\nVibration Motor: OK"
    DispatchQueue.main.async {
      self.topLabel.text = ""
      self.centerLabel.attributedText = Helper.colorText("Testing Done - 100%", colorString: ["100%"], bold: true)
      DispatchQueue.main.asyncAfter(deadline: .now() + Double.random()) {
        self.centerLabel.attributedText = Helper.colorText(text_0, colorString: ["100%", "OK"], bold: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random()) {
          self.centerLabel.attributedText = Helper.colorText(text_1, colorString: ["100%", "OK"], bold: true)
          DispatchQueue.main.asyncAfter(deadline: .now() + Double.random()) {
            self.centerLabel.attributedText = Helper.colorText(text_2, colorString: ["100%", "OK"], bold: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random()) {
              self.centerLabel.attributedText = Helper.colorText(text_3, colorString: ["100%", "OK"], bold: true)
              DispatchQueue.main.asyncAfter(deadline: .now() + Double.random()) {
                self.centerLabel.attributedText = Helper.colorText(text_4, colorString: ["100%", "OK"], bold: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + Double.random()) {
                  self.centerLabel.attributedText = Helper.colorText(text_5, colorString: ["100%", "OK"], bold: true)
                  DispatchQueue.main.asyncAfter(deadline: .now() + Double.random()) {
                    self.centerLabel.attributedText = Helper.colorText(text_6, colorString: ["100%", "OK"], bold: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double.random()) {
                      self.centerLabel.attributedText = Helper.colorText(text_7, colorString: ["100%", "OK"], bold: true)
                      DispatchQueue.main.asyncAfter(deadline: .now() + Double.random()) {
                        self.centerLabel.attributedText = Helper.colorText(text_8, colorString: ["100%", "OK"], bold: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random()) {
                          self.centerLabel.attributedText = Helper.colorText(text_9, colorString: ["100%", "OK"], bold: true)
                          DispatchQueue.main.asyncAfter(deadline: .now() + Double.random()) {
                            self.centerLabel.attributedText = Helper.colorText(text_10, colorString: ["100%", "OK"], bold: true)
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random()) {
                              self.centerLabel.attributedText = Helper.colorText(text_11, colorString: ["100%", "OK"], bold: true)
                              DispatchQueue.main.asyncAfter(deadline: .now() + Double.random()) {
                                self.centerLabel.attributedText = Helper.colorText(text_12, colorString: ["100%", "OK"], bold: true)
                                DispatchQueue.main.asyncAfter(deadline: .now() + Double.random()) {
                                  self.centerLabel.attributedText = Helper.colorText(text_13, colorString: ["100%", "OK"], bold: true)
//                                  self.waveformImageView.isUserInteractionEnabled = false
                                  self.waveformImageView.alpha = 1
                                  self.nextButton.alpha = 1
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}


