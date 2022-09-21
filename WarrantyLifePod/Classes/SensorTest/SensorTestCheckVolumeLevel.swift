//
//  SensorTestCheckVolumeLevel.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-07.
//

import Foundation
import UIKit

// Check volume level: minium is 75%

extension SensorTestViewController {
  
  func checkVolumeLevel() {
    guard !runCaseDetectionOnDrop else { return }
    guard let volume = AudioManager.shared.volume else {
//      fatalError()
//      showIncreaseVolumePopup()
      return
    }
//    #if DEBUG
//    #else
    let miniumVolueRequired: Float = 0.75
    if volume < miniumVolueRequired {
      showIncreaseVolumePopup()
    }
//    #endif
  }
  
  private func showIncreaseVolumePopup() {
    #if !targetEnvironment(simulator)
    
    DispatchQueue.main.async {
      let alertController = UIAlertController.init(title: nil, message: "For best results, please turn the volume up to 3/4 or higher.", preferredStyle: .alert)
      alertController.addAction(UIAlertAction.init(title: "I'm done!", style: .default, handler: { _ in
        self.checkVolumeLevel()
      }))
      self.present(alertController, animated: true, completion: nil)
    }

    #endif
  }
}
