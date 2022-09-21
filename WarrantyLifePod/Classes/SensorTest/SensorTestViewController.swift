//
//  SensorTestViewController.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-01.
//

import UIKit
import CoreMotion

class SensorTestViewController: UIViewController {
  // UI
  var titleView: UIView!
  var titleLable: UILabel!
  var backButton: UIButton!
  var menuButton: UIButton!
  var nextButton: UIButton!
  var startButton: UIButton!
  
  var waveformImageView: UIImageView!
  var topLabel: UILabel!
  var centerLabel: UILabel!
  var bottomLabel: UILabel! // debug window, ddt or debug using only
  // screen protector test
  var screenProtectorTestView: UIView!
  var imagePickerController = UIImagePickerController()
  var isReferenceImageTaken = false

  var sensorTestModel: SensorTestModel!
  let toneOutputUnit = ToneOutputUnit()
  var toneOutputUnitTimer: Timer?
  var currentSensorTestPhaseOrder: Int?
  var userStartsTest = false
  var totalTestDuration: Double = 0.0
  var startTime = Date()
  var isFaceDown = false
  var isTakingPhoto = false
  var runCaseDetectionOnDrop = false
  
  // device motion
  let motionManager = CMMotionManager()
  let altimeter = CMAltimeter()
  var altitudeData: CMAltitudeData?
  var models: [DeviceMotionDataModel] = []
  var stableDuration: TimeInterval = 0.0
  
  #warning("temp props need to remove for release")
  var recordedAudioLength: Double!
  var apiPassedCount = 0
  var apiFailedCount = 0
  var realTestDur = ""
  var audioLength = ""
  
  // ddt
  var numberOfRuns: Int = 1
  var ddtModel: DDTModel?
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  init(sensorTestModel: SensorTestModel, ddtModel: DDTModel? = nil) {
    self.sensorTestModel = sensorTestModel
    self.ddtModel = ddtModel
    self.numberOfRuns = ddtModel?.numberOfRuns ?? 1
    self.isFaceDown = UserDefaults.standard.bool(forKey: "NeedToDoScreenProtectorTest")
    self.runCaseDetectionOnDrop = sensorTestModel.id == "6"
    
    for p in sensorTestModel.sensorTestPhases {
      print(p.id, p.phase, p.durationMs, p.startFreq, p.endFreq)
    }

    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    overrideUserInterfaceStyle = .light
    UIApplication.shared.isIdleTimerDisabled = true
    totalTestDuration = sensorTestModel.totalDuration

    setupUI()
    updateDebugWindowInfo()
    checkMicrophonePermission()
    checkVolumeLevel()
    
    if runCaseDetectionOnDrop {
      waveformImageViewClicked()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    UserDefaults.standard.removeObject(forKey: "DropDate")
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
//    doingCaseDetectionOnDrop = false
    stopTest()
  }

  func prepareForTheTest() {
    models.removeAll()
    
    toneOutputUnit.enableSpeaker()
    startDeviceMotionUpdate()
    if !runCaseDetectionOnDrop {
      _ = AudioManager.shared
    }
  }
  
  func startTesting() {
    startTime = Date()
    
    currentSensorTestPhaseOrder = -1
    loopSensorTestModelPhases()
    if !runCaseDetectionOnDrop {
      AudioManager.shared.startRecording()
    }
  }
  
  func stopTest() {
    stopEverythingExceptMotion()
    stopDevieMotionUpdate()
    stopTakingPhotos()
  }
  
  func deviceMovementDetectedDuringTest() {
    print(#function)
    stopTest()
    
    AudioManager.shared.playFailSound()
    
    if runCaseDetectionOnDrop {
      dismiss(animated: false, completion: nil)
    } else {
      showDeviceMovementDetectedDuringTestPopup()
    }
  }
  
  // for taking photos we still want motion running so we can detect if there is a movement during taking photos
  private func stopEverythingExceptMotion() {
    isReferenceImageTaken = false
    toneOutputUnitTimer?.invalidate()
    toneOutputUnitTimer = nil
    toneOutputUnit.stop()
    currentSensorTestPhaseOrder = nil
    if !runCaseDetectionOnDrop {
      recordedAudioLength = AudioManager.shared.audioRecorder!.currentTime // temp
      AudioManager.shared.stopRecording()
    }
  }
  
  func loopSensorTestModelPhasesFinished() {
    if isFaceDown {
      stopEverythingExceptMotion()
      startTakingReferenceImageAndTestImage()
    } else {
      finishedTest()
    }
  }

  func finishedTest() {
    showFinishedTestAnimation()
    userStartsTest = false
    numberOfRuns -= 1
    stopTest()
    saveSensorTestData()
    
    if runCaseDetectionOnDrop {
      #if DEBUG
      AudioManager.shared.playDing()
      #endif
      DispatchQueue.main.async {
        self.dismiss(animated: false, completion: nil)
      }
    } else {
      updateDebugWindowInfo()
      AudioManager.shared.playDing()
    }
  }
  
  private func saveSensorTestData() {
    let sensorEventType = runCaseDetectionOnDrop ? 1200 : 1111
    let volumeSetting = runCaseDetectionOnDrop ? -1 : Int(AudioManager.shared.volume! * 100)
    let event = SensorEvent(sensorEventType: sensorEventType, volumeSetting: volumeSetting, sensorTestId: sensorTestModel.id)
    let audioURL = runCaseDetectionOnDrop ? nil : AudioManager.shared.renameAudioURL(to: event.eventAt)
    let apiDataModel = SensorEventAPIDataModel(event: event, readings: models, audio: audioURL)
    print("\n\napiDataModel readings -> \(apiDataModel.readings.count)\n\n")
    
//    Helper.prt(txt: "model audio size -> \(Helper.fileSize(forURL: apiDataModel.audio!))")
    
    if runCaseDetectionOnDrop {
      sendSensorTestData(apiDataModel)
    } else {
      do {
        let encoded = try JSONEncoder().encode(apiDataModel)
        UserDefaults.standard.setValue(encoded, forKey: kSensorTestData)
        UserDefaults.standard.synchronize()
      } catch {
        Logger.logFatalError(title: #function, error)
      }
    }
  }
  
  private func sendSensorTestData(_ apiDataModel: SensorEventAPIDataModel) {
    if let itemId = UserDefaults.standard.string(forKey: "itemId") {
        NetworkManager.shared.uploadSensorEventData(itemId: itemId, apiDataModel: apiDataModel) { result in

          switch result {
          case .success():
            UserDefaults.standard.removeObject(forKey: "DropDate")
            print("send sensor test 6 succeed!!!")
          case .failure(_):
            OfflineManager.shared.appendModel(apiDataModel)
          }
        }
    } else {
      Logger.logFatalError(title: "Where the hell is ItemId ???")
    }
  }
}
