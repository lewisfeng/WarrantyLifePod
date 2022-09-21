//
//  SensorTestCheckPermission.swift
//  DiagnosticApp
//
//  Created by YI BIN FENG on 2022-03-10.
//  Copyright © 2022 cellairis. All rights reserved.
//

import UIKit
import AVFoundation

// check permission
extension SensorTestViewController {
  
  func checkMicrophonePermission() {
    AudioManager.shared.checkMicrophoneAccess { granted in
      if granted {
        if self.isFaceDown {
          self.checkForCameraPermission()
        } else {
          DispatchQueue.main.async {
            self.waveformImageView.isUserInteractionEnabled = true
            self.startButton.isHidden = false
          }
        }
      } else {
        self.needMicrophoneAlert()
      }
    }
  }
  
  private func checkForCameraPermission() {
    if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
      DispatchQueue.main.async {
        self.waveformImageView.isUserInteractionEnabled = true
        self.startButton.isHidden = false
      }
    } else {
      AVCaptureDevice.requestAccess(for: .video) { granted in
        DispatchQueue.main.async {
          if granted {
            self.waveformImageView.isUserInteractionEnabled = true
            self.startButton.isHidden = false
          } else {
            let alert = UIAlertController(title: NSLocalizedString("cameraPermissionRequired", comment: "Camera permission required"), message: NSLocalizedString("cameraPermissionMessage", comment: "Warranty Life requires permission to access camera for test to continue."), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("popup_setting", comment: "Setting"), style: .default, handler: {(alert: UIAlertAction!) in
                DispatchQueue.main.async {
                  if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                  }
                }
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("popup_cancel", comment: "Cancel"), style: .cancel, handler: { _ in
              self.waveformImageView.isUserInteractionEnabled = true
              self.startButton.isHidden = false
            }))
            
            self.present(alert, animated: true)
          }
        }
      }
    }
  }
  
  private func needMicrophoneAlert() {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: NSLocalizedString("MicrophonePermissionRequired", comment: "Microphone permission required"), message: NSLocalizedString("MicrophonePermissionMessage", comment: "Warranty Life requires permission to access Microphone for Microphone Test."), preferredStyle: .alert)
      
      alert.addAction(UIAlertAction(title: NSLocalizedString("popup_setting", comment: "Setting"), style: .default, handler: {(alert: UIAlertAction!) in
          DispatchQueue.main.async {
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
          }
      }))
      alert.addAction(UIAlertAction(title: NSLocalizedString("popup_cancel", comment: "Cancel"), style: .cancel, handler: { _ in

      }))
      
      self.present(alert, animated: true)
    }
  }
}
