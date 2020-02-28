//
//  RNPlayPauseButton.swift
//  Playlist
//
//  Created by Alex Stokes on 2/27/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

@objc(RNPlayPauseButton)
class RNPlayPauseButton : RCTViewManager {
  override func view() -> UIView! {
    return RNPlayPauseButtonView(type: .custom)
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
}


class RNPlayPauseButtonView: UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.frame = frame
       
    self.setImage(UIImage(named: "play.png", in: RNPlaylistGlobal.getResourceBundle(), compatibleWith: nil), for: .normal)
    self.setImage(UIImage(named: "pause.png", in: RNPlaylistGlobal.getResourceBundle(), compatibleWith: nil), for: .selected)
    
    self.addTarget(self, action: #selector(self.onPress), for: .touchUpInside)
    
    
    
    NotificationCenter.default.addObserver(self,
        selector: #selector(onPlayerStateChange),
        name: .onPlayerStateChange,
        object: nil
    )
  }
  
  // isPlaying Observer
  @objc private func onPlayerStateChange(_ notification: Notification) {
    guard let isPlaying = notification.object as? Bool else {
      print("isPlaying is no good")
      return
    }
    print("isPlaying", isPlaying)
    self.isSelected = isPlaying ? true : false
  }
  

  // On Press Handler
  @objc(onPress:)
  func onPress(sender: UIButton!) {
    SwiftPlayer.playToggle()
  }


  // Props
  @objc var playButtonImage: String = "play" {
    didSet {
      self.setImage(UIImage(named: playButtonImage), for: .normal)
    }
  }
  
  @objc var pauseButtonImage: String = "pause" {
    didSet {
      self.setImage(UIImage(named: pauseButtonImage), for: .selected)
    }
  }
  
  // Etc
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}