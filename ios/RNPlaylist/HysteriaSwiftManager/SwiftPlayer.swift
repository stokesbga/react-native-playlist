//
//  SwiftPlayer.swift
//  Pods
//
//  Created by iTSangar on 1/14/16.
//
//

import Foundation
import MediaPlayer

// MARK: - SwiftPlayer Struct -
/// Struct to access player actions 🎵
open class SwiftPlayer {
  
  /// Setup Hysteria Player
  public static func setup() {
    HysteriaManager.sharedInstance.initHysteriaPlayer()
  }
  
  /// Teardown Hysteria Player
  public static func teardown() {
    HysteriaManager.sharedInstance.pause()
    HysteriaManager.sharedInstance.teardownHysteriaPlayer()
  }
  
  /// Set logs
  public static func logs(_ active: Bool) {
    HysteriaManager.sharedInstance.logs = active
  }
  
  /// Set useCache
  public static func enableCache(_ enable: Bool) {
    HysteriaManager.sharedInstance.setMemoryCached(enable)
  }
  
  /// Set enable callbacks for CF Signing
  public static func enableTrackUrlCallbacks() {
    HysteriaManager.sharedInstance.enableTrackUrlCallbacks = true
  }
  
  
  /// ▶️ Play music
  public static func play() {
    HysteriaManager.sharedInstance.play()
  }
  
  /// ▶️🔢 Play music by specified index
  public static func playAtIndex(_ index: Int) {
    HysteriaManager.sharedInstance.playAtIndex(index)
  }
  
  /// ▶️0️⃣ Play all tracks starting by 0
  public static func playAll() {
    HysteriaManager.sharedInstance.playAllTracks()
  }
  
  public static func setTrackURLs(_ urls: [String]) {
    let nsUrls = urls.map({ URL(string:$0)! })
    HysteriaManager.sharedInstance.setupPlayerItems(nsUrls)
  }
  
  public static func playToggle() {
    self.isPlaying() ? HysteriaManager.sharedInstance.pause() : HysteriaManager.sharedInstance.play()
  }
  
  /// ⏸ Pause music if music is playing
  public static func pause() {
    HysteriaManager.sharedInstance.pause()
  }
  
  /// ⏩ Play next music
  public static func next() {
    HysteriaManager.sharedInstance.next()
  }
  
  /// ⏪ Play previous music
  public static func previous() {
    HysteriaManager.sharedInstance.previous()
  }
  
  /// Return true if sound is playing
  public static func isPlaying() -> Bool {
    return HysteriaManager.sharedInstance.hysteriaPlayer!.isPlaying()
  }
  
  /// 🔀 Enable the player shuffle
  public static func enableShuffle() {
    HysteriaManager.sharedInstance.enableShuffle()
  }
  
  /// Disable player shuffle
  public static func disableShuffle() {
    HysteriaManager.sharedInstance.disableShuffle()
  }
  
  /// Return true if 🔀 shuffle is enable
  public static func isShuffle() -> Bool {
    return HysteriaManager.sharedInstance.shuffleStatus()
  }
  
  /// 🔁 Enable repeat mode on music list
  public static func enableRepeat() {
    HysteriaManager.sharedInstance.enableRepeat()
  }
  
  /// 🔂 Enable repeat mode only in actual music
  public static func enableRepeatOne() {
    HysteriaManager.sharedInstance.enableRepeatOne()
  }
  
  /// Disable repeat mode
  public static func disableRepeat() {
    HysteriaManager.sharedInstance.disableRepeat()
  }
  
  /// Return true if 🔁 repeat or 🔂 repeatOne is enable
  public static func isRepeat() -> Bool {
    let (_, _, Off) = HysteriaManager.sharedInstance.repeatStatus()
    return !Off
  }
  
  /// Return true if 🔂 repeatOne is enable
  public static func isRepeatOne() -> Bool {
    let (_, One, _) = HysteriaManager.sharedInstance.repeatStatus()
    return One
  }
  
  /// 🔘 Set new seek value from UISlider
  public static func seekToWithSlider(_ slider: UISlider) {
    HysteriaManager.sharedInstance.seekTo(slider)
  }
  
  public static func seekToS(_ seconds: Double) {
    HysteriaManager.sharedInstance.seekToS(seconds)
  }
  
  /// Get duration time
  public static func getDuration() -> Float {
    return HysteriaManager.sharedInstance.playingItemDurationTime()
  }
  
  /// Current Position Time
  public static func getPosition() -> Float {
    return HysteriaManager.sharedInstance.getCurrentPosition()
  }
  
  /// 🔊 Player volume view
  public static func volumeViewFrom(_ view: UIView) -> MPVolumeView {
    return HysteriaManager.sharedInstance.volumeViewFrom(view)
  }
  
  // MARK: QUEUE
 
  /// Set new playlist in player
  public static func setPlaylist(_ playlist: [PlayerTrack]) -> SwiftPlayer.Type {
    HysteriaManager.sharedInstance.setPlaylist(playlist)
    return self
  }
  
  /// Get playlist queue
  public static func getPlaylist() -> [PlayerTrack] {
    return HysteriaManager.sharedInstance.getPlayerQueue()
  }
  
  /// Add new track in next queue
  public static func addNextTrack(_ track: PlayerTrack) {
    HysteriaManager.sharedInstance.addPlayNext(track)
  }
  
  /// Total tracks in playlists
  public static func totalTracks() -> Int {
    return HysteriaManager.sharedInstance.queue.totalTracks()
  }
  
  /// Total tracks in previous playlist
  public static func totalPrevTracks() -> Int {
    let idx = HysteriaManager.sharedInstance.currentIndex()
    return idx ?? 0
  }
  
  /// Tracks in main queue
  public static func mainTracks() -> [PlayerTrack] {
    return HysteriaManager.sharedInstance.queue.main
  }
  
  /// Tracks without playing track in next queue
  public static func nextTracks() -> [PlayerTrack] {
    if let index = SwiftPlayer.currentTrackIndex() {
      if SwiftPlayer.trackAtIndex(index).origin == TrackType.next {
        var pop = HysteriaManager.sharedInstance.queue.next
        pop.remove(at: 0)
        return pop
      }
    }
    
    return HysteriaManager.sharedInstance.queue.next
  }
  
  /// All tracks by index 
  public static func trackAtIndex(_ index: Int) -> PlayerTrack {
    return HysteriaManager.sharedInstance.queue.trackAtIndex(index)
  }
  
  /// Current PlayerTrack
  public static func currentPlayerTrack() -> PlayerTrack? {
    return HysteriaManager.sharedInstance.currentPlayerTrack()
  }
    
  /// Current AVPlayerItem
  public static func currentItem() -> AVPlayerItem {
    return HysteriaManager.sharedInstance.currentItem()
  }
  
  /// Current index of playlist
  public static func currentTrackIndex() -> Int? {
    return HysteriaManager.sharedInstance.currentIndex()
  }
  
  /// Play music from main queue by specified index
  public static func playMainAtIndex(_ index: Int) {
    HysteriaManager.sharedInstance.playMainAtIndex(index)
  }
  
  /// Play music from next queue by specified index
  public static func playNextAtIndex(_ index: Int) {
    HysteriaManager.sharedInstance.playNextAtIndex(index)
  }
}
