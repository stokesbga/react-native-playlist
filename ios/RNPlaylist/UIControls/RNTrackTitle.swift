//
//  RNTrackTitle.swift
//  Playlist
//
//  Created by Alex Stokes on 2/28/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import MarqueeLabel


@objc(RNTrackTitle)
class RNTrackTitle : RCTViewManager {
  override func view() -> UIView! {
    return RNTrackTitleView()
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
}


class RNTrackTitleView: UIView {
  private var fontFamily: String = "System"
  private var fontSize: CGFloat = 18.0
  private var color: UIColor = .black
  private var textAlign: NSTextAlignment = .left
  private lazy var marqueeLabel: MarqueeLabel = {
  let label = MarqueeLabel(frame: CGRect())
    // Marquee Label props
    label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    label.speed = .rate(60)
    label.animationDelay = 0.5
    label.fadeLength = 50
    label.trailingBuffer = 50
    
    // Text props
    label.contentMode = .center
    label.textAlignment = textAlign
    label.textColor = color
    label.text = RNPlaylist.emptyTrackTitle
    return label
  }()
    
  override init(frame: CGRect) {
    super.init(frame: frame)
        
    marqueeLabel.frame = frame
    addSubview(marqueeLabel)
    
    // Notification Subscriber
    NotificationCenter.default.addObserver(self,
      selector: #selector(onTrackChange),
      name: .onTrackChange,
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
        let track = SwiftPlayer.trackAtIndex(SwiftPlayer.currentTrackIndex() as? Int ?? 0)
        marqueeLabel.text = track.name ?? RNPlaylist.emptyTrackTitle
      } else {
        marqueeLabel.text = RNPlaylist.emptyTrackTitle
      }
    }
  }
  
  // Track Change Observer
  @objc private func onTrackChange(_ notification: Notification) {
    DispatchQueue.main.async {
      guard let track = notification.object as? PlayerTrack else { return }
      self.marqueeLabel.text = track.AVMediaPlayerProperties?["title"] as? String ?? "None"
    }
  }
  
  // On Queue State Change Observer (empty, item added)
  @objc private func onQueueStateChange(_ notification: Notification) {
    DispatchQueue.main.async {
      guard let isReady = notification.object as? Bool else { return }
      if(!isReady) {
        self.marqueeLabel.text = RNPlaylist.emptyTrackTitle
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
extension RNTrackTitleView {
  
  @objc public func setFontFamily(_ val: NSString) {
    fontFamily = val as? String ?? "System"
    let font = UIFont(name: fontFamily, size: fontSize)
    marqueeLabel.font = font
  }
  
  @objc public func setFontSize(_ val: NSNumber) {
    fontSize = RCTConvert.cgFloat(val) ?? 18
    let font = UIFont(name: fontFamily, size: fontSize)
    marqueeLabel.font = font
  }
  
  @objc public func setColor(_ val: NSNumber) {
    color = RCTConvert.uiColor(val) ?? .black
    marqueeLabel.textColor = color
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
    marqueeLabel.textAlignment = textAlign
  }
  
  // Marquee Props
  @objc public func setMarqueeSpeed(_ val: NSNumber) {
    marqueeLabel.speed = .rate(CGFloat(val))
  }
  
  @objc public func setMarqueeDelay(_ val: NSNumber) {
    marqueeLabel.animationDelay = CGFloat(val)
  }
  
  @objc public func setMarqueeFadeLength(_ val: NSNumber) {
    marqueeLabel.fadeLength = CGFloat(val)
  }
  
  @objc public func setMarqueeTrailingMargin(_ val: NSNumber) {
    marqueeLabel.trailingBuffer = CGFloat(val)
  }
    
}
