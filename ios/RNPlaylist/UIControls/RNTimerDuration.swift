//
//  RNTrackDetails.swift
//  Playlist
//
//  Created by Alex Stokes on 2/27/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation


@objc(RNTimerDuration)
class RNTimerDuration : RCTViewManager {
  override func view() -> UIView! {
    return RNTimerDurationView()
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
}


class RNTimerDurationView: UILabel {
  // React Props
  private var fontFamily: String = "System"
  private var fontSize: CGFloat = 18.0
  private var color: UIColor = .black
  private var textAlign: NSTextAlignment = .left
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.frame = frame
    
    self.textAlignment = textAlign
    self.textColor = color
    self.text = "0:00"
    
    // Notification Subscriber
    NotificationCenter.default.addObserver(self,
      selector: #selector(onTrackDurationChange),
      name: .onTrackDurationChange,
      object: nil
    )
    NotificationCenter.default.addObserver(self,
      selector: #selector(onQueueStateChange),
      name: .onQueueStateChange,
      object: nil
    )
  }

  override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)

    if newWindow == nil {
      // UIView disappear
    } else {
      if (PlaylistService.isQueueReady) {
        guard let duration = SwiftPlayer.getDuration() as? Float else {
          self.text = "0:00"
          return
        }
        self.text = duration.toTimerString()
      } else {
        self.text = "0:00"
      }
    }
  }
  
  // Track Position Observer
  @objc private func onTrackDurationChange(_ notification: Notification) {
    DispatchQueue.main.async {
      guard let seconds = notification.object as? Float else { return }
      self.text = seconds.toTimerString()
    }
  }
  
  // On Queue State Change Observer (empty, item added)
  @objc private func onQueueStateChange(_ notification: Notification) {
    DispatchQueue.main.async {
      guard let isReady = notification.object as? Bool else { return }
      if(!isReady) {
        self.text = "0:00"
      }
    }
  }

    
  // Required
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


/**************
*  React Props  *
**************/
extension RNTimerDurationView {
  
  @objc public func setFontFamily(_ val: NSString) {
    fontFamily = val as? String ?? "System"
    let font = UIFont(name: fontFamily, size: fontSize)
    self.font = font
  }
  
  @objc public func setFontSize(_ val: NSNumber) {
    fontSize = RCTConvert.cgFloat(val) ?? 18
    let font = UIFont(name: fontFamily, size: fontSize)
    self.font = font
  }
  
  @objc public func setColor(_ val: NSNumber) {
    color = RCTConvert.uiColor(val) ?? .black
    self.textColor = color
  }
  
  @objc public func setTextAlign(_ val: NSNumber) {
    textAlign = {
      switch(val as? Int ?? 0) {
      case 0:
        return .left
      case 1:
        return .center
      case 2:
        return .right
      default:
        return .left
      }
    }()
    self.textAlignment = textAlign
  }
  
}
