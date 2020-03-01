//
//  RNPlaylistService.swift
//  Playlist
//
//  Created by Alex Stokes on 2/28/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

@objc(RNPlaylistService)
class PlaylistService: NSObject {

  @objc static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  private static var playerIsReady: Bool = false
  
  
  /**
   * Triggers
   */
  // Track
  var onTrackPreloaded: ((_ time: CMTime?)->())?
  var onTrackWillChange: ((_ index: Int?)->())?
  var onTrackChange: ((_ track: PlayerTrack?)->())?
  var onTrackPlayReady: (()->())?
  var onTrackPositionChange: ((_ seconds: Float?)->())?
  var onTrackDurationChange: ((_ seconds: Float?)->())?
  
  // Player
  var onPlayerStateChange: ((_ isPlaying: Bool)->())?
  var onPlayerReachedEnd: (()->())?
  var onPlayerReady: (()->())?
  var onPlayerStall: (()->())?
  
  // Error
  var onTrackLoadFailed: ((_ error: NSError?)->())?
  var onPlayerFailed: ((_ error: NSError?)->())?
  
  /**
  * Dispatchers
  */
  
  // Track
  func dispatchTrackPreloaded(_ time: CMTime?) {
//    onTrackPreloaded?(time)
  }
  func dispatchTrackWillChange(_ index: Int?) {
    NotificationCenter.default.post(name: .onTrackWillChange, object: index)
  }
  func dispatchTrackChange(_ track:  [String: AnyObject]?) {
    NotificationCenter.default.post(name: .onTrackChange, object: track)
  }
  func dispatchTrackPlayReady() {
//    onTrackPlayReady?()
  }
  func dispatchTrackPositionChange(_ seconds: Float?) {
    NotificationCenter.default.post(name: .onTrackPositionChange, object: seconds)
  }
  func dispatchTrackDurationChange(_ seconds: Float?) {
    NotificationCenter.default.post(name: .onTrackDurationChange, object: seconds)
  }
  
  // Player
  func dispatchPlayerStateChange(_ isPlaying: Bool) {
    if(PlaylistService.playerIsReady) {
      NotificationCenter.default.post(name: .onPlayerStateChange, object: isPlaying)
    }
  }
  func dispatchPlayerReachedEnd() {
//    onPlayerReachedEnd?()
  }
  func dispatchPlayerReady() {
    PlaylistService.playerIsReady = true
  }
  func dispatchPlayerStall() {
//    playerIsReady = false
  }
  
  // Error
  func dispatchTrackLoadFailed(_ error: NSError?) {
//    onTrackLoadFailed?(error)
  }
  func dispatchPlayerFailed(_ error: NSError?) {
    PlaylistService.playerIsReady = false
  }
}


extension Notification.Name {
  static let onPlayerStateChange = Notification.Name("onPlayerStateChange")
  static let onTrackPositionChange = Notification.Name("onTrackPositionChange")
  static let onTrackDurationChange = Notification.Name("onTrackDurationChange")
  static let onTrackChange = Notification.Name("onTrackChange")
  static let onTrackWillChange = Notification.Name("onTrackWillChange")
  
//  static let didCompleteTask = Notification.Name("didCompleteTask")
//  static let didCompleteTask = Notification.Name("didCompleteTask")
  

//  static var playbackStopped: Notification.Name {
//    return .init(rawValue: "PlaylistService.playbackStopped")
//  }
//
//  static var playbackStarted: Notification.Name {
//    return .init(rawValue: "PlaylistService.playbackStarted")
//  }
//
//  static var playbackPaused: Notification.Name {
//    return .init(rawValue: "PlaylistService.playbackPaused")
//  }
//
//  static var playbackStopped: Notification.Name {
//    return .init(rawValue: "PlaylistService.playbackStopped")
//  }
//  static var playbackStarted: Notification.Name {
//    return .init(rawValue: "PlaylistService.playbackStarted")
//  }
//
//  static var playbackPaused: Notification.Name {
//    return .init(rawValue: "PlaylistService.playbackPaused")
//  }
//
//  static var playbackStopped: Notification.Name {
//    return .init(rawValue: "PlaylistService.playbackStopped")
//  }
//
//  static var playbackStarted: Notification.Name {
//    return .init(rawValue: "PlaylistService.playbackStarted")
//  }
//
//  static var playbackPaused: Notification.Name {
//    return .init(rawValue: "PlaylistService.playbackPaused")
//  }
//
//  static var playbackStopped: Notification.Name {
//    return .init(rawValue: "PlaylistService.playbackStopped")
//  }
//
//  static var playbackStarted: Notification.Name {
//    return .init(rawValue: "PlaylistService.playbackStarted")
//  }
//
//  static var playbackPaused: Notification.Name {
//    return .init(rawValue: "PlaylistService.playbackPaused")
//  }
//
//  static var playbackStopped: Notification.Name {
//    return .init(rawValue: "PlaylistService.playbackStopped")
//  }
}
