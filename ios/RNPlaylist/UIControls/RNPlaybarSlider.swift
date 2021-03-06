//
//  RNPlaybarSlider.swift
//  Playlist
//
//  Created by Alex Stokes on 2/26/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation


@objc(RNPlaybarSlider)
class RNPlaybarSlider : RCTViewManager {
  override func view() -> UIView! {
     return RNPlaybarSliderView()
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
}


class RNPlaybarSliderView: UISlider {
  // React Props
  private var hasControl: Bool = false
  private var thumbRadius: CGFloat = 18
  private var trackHeightEnabled: CGFloat = 6
  private var trackHeightDisabled: CGFloat = 4
  private var trackPlayedColor: UIColor = .blue
  private var trackRemainingColor: UIColor = .lightGray
  
  private var range: Float = 1000
  private var unanimatedBoundLow: Float = 50
  private var unanimatedBoundHigh: Float = 950
  private var isSeeking: Bool = false

  private lazy var thumbViewEnabled: UIView = {
    let thumb = UIView()
    thumb.backgroundColor = .white
    thumb.layer.borderWidth = 0.3
    thumb.layer.borderColor = UIColor.lightGray.cgColor
    return thumb
  }()
  private lazy var thumbViewDisabled: UIImage = UIImage()

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.frame = frame

    self.minimumValue = 0
    self.maximumValue = 100
    self.range = self.maximumValue - self.minimumValue
    self.unanimatedBoundLow = self.maximumValue * 0.02
    self.unanimatedBoundHigh = self.maximumValue - (self.maximumValue * 0.02)
    self.isContinuous = true
    
    // Custom Thumb Image
    self.updateThumbImg(hasControl)
    
    // On Seek Listener
    self.addTarget(self, action: #selector(self.onSeek), for: .valueChanged)
    
    // Notification Subscriber
    NotificationCenter.default.addObserver(self,
      selector: #selector(onTrackPositionChange),
      name: .onTrackPositionChange,
      object: nil
    )
  }
  
  override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)

    if newWindow == nil {
      // UIView disappear
    } else {
      if (PlaylistService.isQueueReady) {
        let val = self.range * (SwiftPlayer.getPosition() / SwiftPlayer.getDuration())
        if(val == Float.infinity) { return }
        self.setValue(val, animated: false)
      }
    }
  }
  
  // Track Position Observer
  @objc private func onTrackPositionChange(_ notification: Notification) {
    DispatchQueue.main.async {
      guard self.isSeeking == false else { return }
      guard let seconds = notification.object as? Float else { return }
      let val = self.range * (seconds / SwiftPlayer.getDuration())
      self.setValue(val, animated: val > self.unanimatedBoundLow && val < self.unanimatedBoundHigh)
    }
  }
  
  
  // On Seek
  @objc public func onSeek(_ source: UISlider, event: UIEvent ) -> Void {
    if let touchEvent = event.allTouches?.first {
      switch touchEvent.phase {
      case .began:
        SwiftPlayer.pause()
        self.isSeeking = true
        break
      case .ended:
        SwiftPlayer.seekToWithSlider(source)
        SwiftPlayer.play()
        self.isSeeking = false
        break
      default:
          break
      }
    }
  }
  
  
  // UISlider Customization
  override func trackRect(forBounds bounds: CGRect) -> CGRect {
    let point = CGPoint(x: bounds.minX, y: bounds.midY)
    return CGRect(origin: point, size: CGSize(width: bounds.width, height: hasControl ? trackHeightEnabled : trackHeightDisabled))
  }
   
  private func thumbImage(radius: CGFloat) -> UIImage {
    self.thumbViewEnabled.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
    self.thumbViewEnabled.layer.cornerRadius = radius / 2
    let renderer = UIGraphicsImageRenderer(bounds: thumbViewEnabled.bounds)
    return renderer.image { rendererContext in
        thumbViewEnabled.layer.render(in: rendererContext.cgContext)
    }
  }
  
  // Update Thumb Img on hasControl prop change
  private func updateThumbImg(_ hasControl: Bool) -> Void {
    if(hasControl) {
      let thumb = thumbImage(radius: self.thumbRadius)
      self.setThumbImage(thumb, for: .normal)
    } else {
      self.setThumbImage(UIImage(), for: .normal)
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
extension RNPlaybarSliderView {
  
  @objc public func setHasControl(_ val: Bool) {
    self.isUserInteractionEnabled = val
    self.hasControl = val
    self.updateThumbImg(val)
  }
    
  @objc public func setThumbRadius(_ val: NSNumber) {
    self.thumbRadius = CGFloat(val)
    self.updateThumbImg(self.hasControl)
  }
  
  @objc public func setTrackHeightEnabled(_ val: NSNumber) {
    self.trackHeightEnabled = CGFloat(val)
  }
  
  @objc public func setTrackHeightDisabled(_ val: NSNumber) {
    self.trackHeightDisabled = CGFloat(val)
  }
  
  @objc public func setTrackPlayedColor(_ val: NSNumber) {
    self.minimumTrackTintColor = RCTConvert.uiColor(val)
  }
  
  @objc public func setTrackRemainingColor(_ val: NSNumber) {
    self.maximumTrackTintColor = RCTConvert.uiColor(val)
  }

}
