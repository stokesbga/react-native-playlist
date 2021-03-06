//
//  RNPlaylistService.swift
//  Playlist
//
//  Created by Alex Stokes on 2/28/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

@objc(RNPlaylistService)
class PlaylistService: RCTEventEmitter {

  public static var isQueueReady: Bool = false
  private static var playerIsReady: Bool = false
  public static var subscribedEvents: [String] = []
  private static var throttler = Throttler(minimumDelay: 0.5)
  public static var shared: PlaylistService?
  
  private func isBridgeReady(_ tag: String) -> Bool {
    return PlaylistService.subscribedEvents.contains(tag)
  }
  
  
  override init() {
    super.init()
    PlaylistService.shared = self
  }
  
  
  
  override public func constantsToExport() -> [AnyHashable: Any] {
    // "IS_PLAYING": "IS_PLAYING",
    return [:]
  }
    
  override public func supportedEvents() -> [String] {
    return [
      "onTrackPreloaded",
      "onTrackWillChange",
      "onTracksAboutToExpire",
      "onTrackChange",
      "onTrackPlayReady",
      "onTrackPositionChange",
      "onTrackDurationChange",
      "onPlayerStateChange",
      "onPlayerReachedEnd",
      "onPlayerReady",
      "onPlayerStall",
      "onQueueUpdate",
      "onTrackLoadFailed",
      "onPlayerFailed",
      
      "remote-play",
      "remote-pause",
      "remote-stop",
      "remote-next",
      "remote-previous",
      "remote-jump-forward",
      "remote-jump-backward",
      "remote-seek",
      "remote-duck"
    ]
  }
  
  override public static func requiresMainQueueSetup() -> Bool {
    return false
  }
  
  
  /**
  * Dispatchers
  */
  
  // Track
  public func dispatchTrackPreloaded(_ time: CMTime?) {
    NotificationCenter.default.post(name: .onTrackPreloaded, object: time)
    guard isBridgeReady("onTrackPreloaded") else { return }
    PlaylistService.shared?.sendEvent(withName: "onTrackPreloaded", body: time)
  }
  public func dispatchTrackWillChange(_ index: Int?) {
    NotificationCenter.default.post(name: .onTrackWillChange, object: index)
    guard isBridgeReady("onTrackWillChange") else { return }
    PlaylistService.shared?.sendEvent(withName: "onTrackWillChange", body: index)
  }
  public func dispatchTracksAboutToExpire(_ tracks: [PlayerTrack]?, index: Int?) {
    guard isBridgeReady("onTracksAboutToExpire") else { return }
    PlaylistService.shared?.sendEvent(withName: "onTracksAboutToExpire", body: ["tracks": tracks, "index": index ])
  }
  public func dispatchTrackChange(_ track: PlayerTrack?) {
    NotificationCenter.default.post(name: .onTrackChange, object: track)
    guard isBridgeReady("onTrackChange") else { return }
    PlaylistService.shared?.sendEvent(withName: "onTrackChange", body: track?.dictionary)
  }
  public func dispatchTrackPlayReady() {
    NotificationCenter.default.post(name: .onTrackPlayReady, object: nil)
    guard isBridgeReady("onTrackPlayReady") else { return }
    PlaylistService.shared?.sendEvent(withName: "onTrackPlayReady", body: nil)
  }
  public func dispatchTrackPositionChange(_ seconds: Float?) {
    NotificationCenter.default.post(name: .onTrackPositionChange, object: seconds)
    PlaylistService.throttler.throttle {
      guard self.isBridgeReady("onTrackPositionChange") else { return }
      PlaylistService.shared?.sendEvent(withName: "onTrackPositionChange", body: seconds)
    }
  }
  public func dispatchTrackDurationChange(_ seconds: Float?) {
    NotificationCenter.default.post(name: .onTrackDurationChange, object: seconds)
    guard isBridgeReady("onTrackDurationChange") else { return }
    PlaylistService.shared?.sendEvent(withName: "onTrackDurationChange", body: seconds)
  }
  
  // Player
  public func dispatchPlayerStateChange(_ isPlaying: Bool) {
    if(PlaylistService.playerIsReady) {
      NotificationCenter.default.post(name: .onPlayerStateChange, object: isPlaying)
      guard isBridgeReady("onPlayerStateChange") else { return }
      PlaylistService.shared?.sendEvent(withName: "onPlayerStateChange", body: isPlaying)
    }
  }
  public func dispatchPlayerReachedEnd() {
    NotificationCenter.default.post(name: .onPlayerReachedEnd, object: nil)
    guard isBridgeReady("onPlayerReachedEnd") else { return }
    PlaylistService.shared?.sendEvent(withName: "onPlayerReachedEnd", body: nil)
  }
  public func dispatchPlayerReady() {
    PlaylistService.playerIsReady = true
    NotificationCenter.default.post(name: .onPlayerReady, object: nil)
    guard isBridgeReady("onPlayerReady") else { return }
    PlaylistService.shared?.sendEvent(withName: "onPlayerReady", body: nil)
  }
  public func dispatchPlayerStall() {
    NotificationCenter.default.post(name: .onPlayerStall, object: nil)
    guard isBridgeReady("onPlayerStall") else { return }
    PlaylistService.shared?.sendEvent(withName: "onPlayerStall", body: nil)
  }
  public func dispatchQueueUpdate(_ queue: PlayerQueue) {
    if (queue.main.count == 0 && PlaylistService.isQueueReady) {
      PlaylistService.isQueueReady = false
      NotificationCenter.default.post(name: .onQueueStateChange, object: false)
    } else if (queue.main.count > 0 && !PlaylistService.isQueueReady) {
      PlaylistService.isQueueReady = true
      NotificationCenter.default.post(name: .onQueueStateChange, object: true)
    }
    NotificationCenter.default.post(name: .onQueueUpdate, object: queue)
    guard isBridgeReady("onQueueUpdate") else { return }
    PlaylistService.shared?.sendEvent(withName: "onQueueUpdate", body: queue)
  }
  
  // Error
  public func dispatchTrackLoadFailed(_ error: Error?, index: Int) {
    NotificationCenter.default.post(name: .onTrackLoadFailed, object: error)
    guard isBridgeReady("onTrackLoadFailed") else { return }
    PlaylistService.shared?.sendEvent(withName: "onTrackLoadFailed", body: index)
  }
  public func dispatchPlayerFailed(_ error: Error?) {
    PlaylistService.playerIsReady = false
    NotificationCenter.default.post(name: .onPlayerFailed, object: error)
    guard isBridgeReady("onPlayerFailed") else { return }
    PlaylistService.shared?.sendEvent(withName: "onPlayerFailed", body: nil)
  }
}


extension Notification.Name {
  static let onTrackPreloaded = Notification.Name("onTrackPreloaded")
  static let onTrackWillChange = Notification.Name("onTrackWillChange")
  static let onTrackChange = Notification.Name("onTrackChange")
  static let onTrackPlayReady = Notification.Name("onTrackPlayReady")
  static let onTrackPositionChange = Notification.Name("onTrackPositionChange")
  static let onTrackDurationChange = Notification.Name("onTrackDurationChange")
  static let onPlayerStateChange = Notification.Name("onPlayerStateChange")
  static let onPlayerReachedEnd = Notification.Name("onPlayerReachedEnd")
  static let onPlayerReady = Notification.Name("onPlayerReady")
  static let onPlayerStall = Notification.Name("onPlayerStall")
  static let onQueueUpdate = Notification.Name("onQueueUpdate")
  static let onQueueStateChange = Notification.Name("onQueueStateChange")
  static let onTrackLoadFailed = Notification.Name("onTrackLoadFailed")
  static let onPlayerFailed = Notification.Name("onPlayerFailed")
}
