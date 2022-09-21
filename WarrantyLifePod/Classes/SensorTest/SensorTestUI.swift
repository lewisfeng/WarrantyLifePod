//
//  SensorTestUI.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-08.
//

import Foundation
import UIKit

extension SensorTestViewController {
  
  func setupUI() {
    view.backgroundColor = .white
    
    // title view
    titleView = UIView()
    add(subView: titleView, to: view)
    titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
    titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
    titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    titleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    // title label
    titleLable = UILabel()
    titleLable.text = "Sensor Test"
    titleLable.font = UIFont(name: "Verdana-Bold", size: 19)
    add(subView: titleLable, to: titleView)
    titleLable.centerXAnchor.constraint(equalTo: titleView.centerXAnchor, constant: 0).isActive = true
    titleLable.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
    
    // back button
    backButton = UIButton(type: .custom)
    backButton.tintColor = .black
    backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
    backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
    add(subView: backButton, to: titleView)
    backButton.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 0).isActive = true
    backButton.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 0).isActive = true
    backButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0).isActive = true
    backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    
    // menu button -> (hide in ddt)
    menuButton = UIButton(type: .custom)
    menuButton.clipsToBounds = true
    menuButton.isHidden = true
    menuButton.setImage(UIImage(named: "letter-r"), for: .normal)
    menuButton.addTarget(self, action: #selector(menuButtonClicked), for: .touchUpInside)
    add(subView: menuButton, to: titleView)
    menuButton.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -10).isActive = true
    menuButton.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
    menuButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
    menuButton.heightAnchor.constraint(equalTo: menuButton.widthAnchor, multiplier: 1).isActive = true
    
    // waveform imageView
    let image = UIImage(named: "sound_test")!
    waveformImageView = UIImageView(image: image)
    waveformImageView.isUserInteractionEnabled = false
//    waveformImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(waveformImageViewClicked)))
    add(subView: waveformImageView, to: view)
    waveformImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    waveformImageView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0).isActive = true
    waveformImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
    waveformImageView.heightAnchor.constraint(equalTo: waveformImageView.widthAnchor, multiplier: image.size.height / image.size.width).isActive = true
    
    // top label
    topLabel = UILabel()
    topLabel.numberOfLines = 0
    topLabel.textAlignment = .center
    topLabel.text = "This is serious science. This next test checks various components of your hardware through sound.\n\nThis won’t take long, click on the Start button to begin."
    topLabel.font = UIFont.systemFont(ofSize: 17)
    add(subView: topLabel, to: view)
    topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    topLabel.topAnchor.constraint(equalTo: waveformImageView.bottomAnchor, constant: 0).isActive = true
    topLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
    
    // center label
    centerLabel = UILabel()
    centerLabel.numberOfLines = 0
    centerLabel.textAlignment = .center
    centerLabel.font = UIFont.systemFont(ofSize: 17)
    add(subView: centerLabel, to: view)
    centerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    centerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    centerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
    centerLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
    
    // bottom label -> ddt or debug using only
    bottomLabel = UILabel()
    bottomLabel.isHidden = ddtModel == nil
    #if DEBUG
    bottomLabel.isHidden = false
    #endif
    bottomLabel.backgroundColor = .systemTeal
    bottomLabel.layer.cornerRadius = 10
    bottomLabel.clipsToBounds = true
    bottomLabel.numberOfLines = 7
    bottomLabel.alpha = 0.5
    bottomLabel.text = "debug window"
    bottomLabel.textAlignment = .center
    bottomLabel.font = UIFont.systemFont(ofSize: 13)
    add(subView: bottomLabel, to: view)
    bottomLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    bottomLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    bottomLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
    bottomLabel.heightAnchor.constraint(equalToConstant: 139).isActive = true
    
    // netx button: in ddt the title is playback(play recorded audio)
    nextButton = UIButton(type: .custom)
    nextButton.alpha = 0
    nextButton.setTitle("Next", for: .normal)
    nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
//    nextButton.titleLabel?.text = nextButton.titleLabel?.text?.uppercased()
    nextButton.backgroundColor = UIColor(hex: "#009966")
    nextButton.clipsToBounds = true
    nextButton.layer.cornerRadius = 25
    nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    add(subView: nextButton, to: view)
    nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    nextButton.topAnchor.constraint(equalTo: centerLabel.bottomAnchor, constant: 20).isActive = true
    nextButton.widthAnchor.constraint(equalToConstant: 133).isActive = true
    nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    startButton = UIButton(type: .custom)
    startButton.setTitle("Start", for: .normal)
    startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
//    nextButton.titleLabel?.text = nextButton.titleLabel?.text?.uppercased()
    startButton.backgroundColor = UIColor(hex: "#009966")
    startButton.clipsToBounds = true
    startButton.layer.cornerRadius = 25
    startButton.addTarget(self, action: #selector(waveformImageViewClicked), for: .touchUpInside)
    add(subView: startButton, to: view)
    startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    startButton.topAnchor.constraint(equalTo: centerLabel.bottomAnchor, constant: 20).isActive = true
    startButton.widthAnchor.constraint(equalToConstant: 133).isActive = true
    startButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
  }
}

extension SensorTestViewController {
  private func add(subView: UIView, to view: UIView) {
    view.addSubview(subView)
    subView.translatesAutoresizingMaskIntoConstraints = false
  }
}
