//
//  ScreenProtectorTest.swift
//  DDT
//
//  Created by YI BIN FENG on 2022-02-10.
//  Copyright © 2022 Warranty Life. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MobileCoreServices

extension SensorTestViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func stopTakingPhotos() {
    isTakingPhoto = false
    DispatchQueue.main.async {
      self.imagePickerController.dismiss(animated: false, completion: nil)
    }
  }
  
  func startTakingReferenceImageAndTestImage() {
    isTakingPhoto = true
    setupImagePickerController()
    takePhoto()
  }
  
  private func setupImagePickerController() {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      DispatchQueue.main.async {
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = .camera
        self.imagePickerController.cameraDevice = .front
        self.imagePickerController.modalPresentationStyle = .overCurrentContext
        self.imagePickerController.modalPresentationCapturesStatusBarAppearance = true
        self.imagePickerController.mediaTypes = [kUTTypeImage as String]
        self.imagePickerController.cameraFlashMode = .off
        self.imagePickerController.allowsEditing = false
        self.imagePickerController.showsCameraControls = false
      }
    }
    
    removeReferenceImageAndTestImage()
  }
  
  private func removeReferenceImageAndTestImage() {
    UserDefaults.standard.removeObject(forKey: "ReferenceImage")
    UserDefaults.standard.removeObject(forKey: "TestImage")
  }
  
  private func takePhoto() {
    DispatchQueue.main.async {
      let overlayView = UIView(frame: UIScreen.main.bounds)
      overlayView.backgroundColor = .black
      self.imagePickerController.cameraOverlayView?.addSubview(overlayView)
      
      self.present(self.imagePickerController, animated: false) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          self.imagePickerController.takePicture()
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIScreen.main.brightness = 1
            overlayView.backgroundColor = .white
          }
        }
      }
    }
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      let imageData = image.pngData()
      if !isReferenceImageTaken {
        isReferenceImageTaken = true
        UserDefaults.standard.set(imageData, forKey: "ReferenceImage")
        UserDefaults.standard.synchronize()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          picker.takePicture()
        }
      } else {
        UserDefaults.standard.set(imageData, forKey: "TestImage")
        UserDefaults.standard.synchronize()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          picker.dismiss(animated: true) {
              
            self.finishedTest()
            print("\n\nall photos are taken!!!\n")
          }
        }
      }
    }
  }
}
