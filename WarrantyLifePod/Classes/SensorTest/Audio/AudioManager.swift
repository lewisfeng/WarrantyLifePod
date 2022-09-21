//
//  Audio Manager.swift
//  DiagnosticApp
//
//  Created by YI BIN FENG on 2022-01-30.
//  Copyright © 2022 cellairis. All rights reserved.
//

import AVFoundation

class AudioManager: NSObject {
  static let shared = AudioManager()

  var soundURL: String! // store in CoreData
  var audioRecorder: AVAudioRecorder?
  var audioPlayer: AVAudioPlayer?
  
  override init() {
    super.init()
    self.setupAudioRecorder()
  }
  
  func startRecording() {
    // first check if player is playing
    if let player = audioPlayer, player.isPlaying {
      player.stop()
    }
    
    if let recorder = audioRecorder {
      if !recorder.isRecording {
        do {
          try AVAudioSession.sharedInstance().setActive(true)
        } catch {
          Logger.logFatalError(title: #function, error)
        }
        // Start recording
        recorder.record()
      } else {
        // Pause recording
        recorder.pause()
      }
    } else {
      Logger.logFatalError(title: "Recorder is not available!")
    }
  }
  
  func stopRecording() {
    if let recorder = audioRecorder, recorder.isRecording {
      audioRecorder?.stop()
      do {
        try AVAudioSession.sharedInstance().setActive(false)
      } catch {
        Logger.logFatalError(title: #function, error)
      }
    }
            
    // Stop the audio player if playing
    if let player = audioPlayer, player.isPlaying {
      player.stop()
    }
  }
  
  func playAudio(url: URL?) {
    if let recorder = audioRecorder, !recorder.isRecording {
      do {
        if let url = url {
          audioPlayer = try AVAudioPlayer(contentsOf: url)
        } else {
          audioPlayer = try AVAudioPlayer(contentsOf: recorder.url)
        }
        audioPlayer?.volume = 1
        audioPlayer?.prepareToPlay()
        audioPlayer?.delegate = self
        audioPlayer?.play()
      } catch {
        Logger.logFatalError(title: #function, error)
      }
    }
  }
  
  private func setupAudioRecorder() {
    // Set the audio file
    let audioFileName = UUID().uuidString + ".wav"
    let audioFileURL = documentDirectory().appendingPathComponent(audioFileName)
    soundURL = audioFileName       // Sound URL to be stored in CoreData
    
    // Setup audio session
    do {
        try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: [.defaultToSpeaker, .mixWithOthers])
        try AVAudioSession.sharedInstance().setAllowHapticsAndSystemSoundsDuringRecording(true)
    } catch {
      Logger.logFatalError(title: #function, error)
    }
    
    // Define the recorder setting
    let recorderSetting: [String : Any] = [AVFormatIDKey:Int(kAudioFormatLinearPCM),
                                           AVSampleRateKey:44100,
                                           AVNumberOfChannelsKey:2,
                                           AVLinearPCMBitDepthKey:16,
                                           AVLinearPCMIsFloatKey:false,
                                           AVLinearPCMIsBigEndianKey:false,
                                           AVEncoderAudioQualityKey:AVAudioQuality.max.rawValue]
    
    audioRecorder = try? AVAudioRecorder(url: audioFileURL, settings: recorderSetting)
    audioRecorder?.delegate = self
    audioRecorder?.isMeteringEnabled = true
    audioRecorder?.prepareToRecord()
  }
}

extension AudioManager {
  // Microphone Access
  func checkMicrophoneAccess(completion: @escaping (Bool) -> Void) {
        // Check Microphone Authorization
      switch AVAudioSession.sharedInstance().recordPermission {
          
      case AVAudioSession.RecordPermission.granted:
        completion(true)
      case AVAudioSession.RecordPermission.denied:
        completion(false)
      case AVAudioSession.RecordPermission.undetermined:
        // Request permission here
        AVAudioSession.sharedInstance().requestRecordPermission({ granted in
          completion(granted)
        })
      @unknown default:
        Logger.logFatalError(title: "unknown microphone permission")
      }
    }
}
//
// MARK: - AVAudioRecorderDelegate
extension AudioManager: AVAudioRecorderDelegate {
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if !flag {
      Logger.logFatalError(title: #function)
    }
  }
}
//
// MARK: - AVAudioPlayerDelegate
extension AudioManager: AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {}
}

// MARK: - Helper
extension AudioManager {
  private func documentDirectory() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
  
  func renameAudioURL(to eventAt: String) -> URL? {
    let url = URL.init(fileURLWithPath: "\(eventAt).wav")
    let toURL = documentDirectory().appendingPathComponent(url.lastPathComponent)
    do {
      try FileManager.default.moveItem(at: audioRecorder!.url, to: toURL)
      return toURL
    } catch {
      Logger.logFatalError(title: "Rename audio url", error)
      return nil
    }
  }
}

//
// MARK: - Check volume level

extension AudioManager {
  
  var volume: Float? {
    do {
      try AVAudioSession.sharedInstance().setActive(true)
      return AVAudioSession.sharedInstance().outputVolume
    } catch {
      Logger.logFatalError(title: #function, error)
      return nil
    }
  }
}

// MARK:
// MARK: - Play ding aduio after sensor test id done
extension AudioManager {
  func playDing() {
    if let url = Bundle.main.url(forResource: "DingC", withExtension: "mp3") {
      playAudio(url: url)
    }
  }
  
  func playFailSound() {
    if let url = Bundle.main.url(forResource: "int", withExtension: "wav") {
      playAudio(url: url)
    }
  }
}
