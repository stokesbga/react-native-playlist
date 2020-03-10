/**
 * Sample React Native App
 *
 * adapted from App.js generated by the following command:
 *
 * react-native init example
 *
 * https://github.com/facebook/react-native
 */

import React, { Component } from "react"
import {
  Platform,
  TouchableOpacity,
  Dimensions,
  StyleSheet,
  Text,
  View
} from "react-native"
import Playlist, {
  PlaylistEventEmitter,
  EventTypes,
  PlaylistComponent
} from "react-native-playlist"

import Tracks from "./Tracks"

const { width: deviceWidth, height: deviceHeight } = Dimensions.get("window")

const {
  PlaybarSlider,
  PlayPause,
  SkipNext,
  SkipPrev,
  TrackProgress,
  TrackDuration,
  TrackAlbumArt,
  TrackArtist,
  TrackTitle
} = PlaylistComponent

export default class App extends Component<{}> {
  state = {
    pidx: 0,
    color1: "teal",
    trackTitle: "N/A",
    currentTrackTitle: "None"
  }

  async componentDidMount() {
    Playlist.setup({
      enableTrackUrlCallbacks: true,
      emptyTrackTitle: "No track selected",
      emptyArtistTitle: "Press any card to start listening",
      enableCache: false,
      enableLogs: false,
      enableEvents: [
        "onTracksAboutToExpire",
        "onTrackChange",
        "onTrackLoadFailed"
      ]
    })

    Playlist.addTracks([])

    // Add Listener
    PlaylistEventEmitter.addListener(EventTypes.onTrackChange, track => {
      console.log("track", track)
      this.setState({ trackTitle: track?.name })
    })

    // Uncomment to replace all audio
    PlaylistEventEmitter.addListener(EventTypes.onTracksAboutToExpire, ({ tracks, indexes }) => {
      console.log('TRACKS ABOUT TO EXPIRE', indexes, tracks)
      Playlist.setupTrackURL("https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_5MG.mp3", indexes[0])
    })

    PlaylistEventEmitter.addListener(EventTypes.onTrackLoadFailed, idx => {
      console.log("TRACK ERROR", idx)
    })
  }

  onPressLoadNextPlaylist = () => {
    let { pidx } = this.state
    if (++pidx > 2) pidx = 0
    this.setState({ pidx })
    Playlist.addTracks(Tracks[pidx])
  }

  onPressGetCurrentTrack = async () => {
    let track = await Playlist.getCurrentTrack()
    if(!track) { return }
    this.setState({ currentTrackTitle: track?.name })
  }

  render() {
    return (
      <View style={styles.container}>
        <View style={{ flex: 1, width: "100%" }}>
          <View style={{ flex: 1, backgroundColor: "#e0e0e0" }}>
            <TrackAlbumArt
              style={{ width: deviceHeight / 2, height: deviceHeight / 2 }}
            />
          </View>
          <View style={{ flex: 1 }}>
            <PlaybarSlider
              hasControl={true}
              thumbRadius={20}
              trackHeightEnabled={5}
              trackHeightDisabled={3}
              trackPlayedColor={this.state.color1}
              trackRemainingColor={this.state.color2}
            />
            <View
              style={{
                marginTop: 15,
                marginBottom: 60
              }}>
              <TrackTitle
                fontFamily={"Avenir-Heavy"}
                fontSize={23}
                color={"#222"}
                textAlign={"center"}
                marqueeSpeed={60}
                marqueeDelay={2.0}
                marqueeFadeLength={50}
                marqueeTrailingMargin={100}
                style={{
                  minHeight: 30,
                  marginBottom: 5,
                  marginTop: 20,
                  marginHorizontal: 50
                }}
              />
              <TrackArtist
                fontFamily={"Monaco"}
                fontSize={19}
                color={"#666"}
                textAlign={"center"}
                style={{ minHeight: 30 }}
              />
            </View>
            <View
              style={{
                flexDirection: "row",
                marginTop: 20,
                alignItems: "space-around"
              }}>
              <TrackProgress
                fontFamily={"Avenir-Heavy"}
                fontSize={15}
                color={"lightgray"}
                textAlign={"center"}
                style={{ minHeight: 50 }}
              />
              <SkipPrev
                disabledOpacity={0.4}
                icon={"previous.png"}
                color={"#444"}
                style={{
                  flex: 0,
                  width: 28,
                  height: 28
                }}
              />
              <PlayPause
                playIcon={"play-circle.png"}
                pauseIcon={"pause-circle.png"}
                color={"#222"}
                disabledOpacity={0.4}
                style={{
                  flex: 0,
                  width: 50,
                  marginHorizontal: 35
                }}
              />
              <SkipNext
                disabledOpacity={0.4}
                icon={"next.png"}
                color={"#444"}
                style={{
                  flex: 0,
                  width: 28,
                  height: 28
                }}
              />
              <TrackDuration
                fontFamily={"Avenir-Heavy"}
                fontSize={15}
                color={"lightgray"}
                textAlign={"center"}
                style={{ minHeight: 50 }}
              />
            </View>
            <View style={{ justifyContent: "center", alignItems: "center" }}>
              <Text
                style={{
                  fontWeight: "600",
                  textAlign: "center",
                  marginTop: 50
                }}>
                Current track title from PlaylistEventEmitter:
              </Text>
              <Text style={{ textAlign: "center" }}>
                {this.state.trackTitle}
              </Text>

              <View style={{ width: '100%', marginTop: 10, paddingHorizontal: 50, flexDirection: 'row', justifyContent: 'space-between'}}>
                <TouchableOpacity onPress={this.onPressLoadNextPlaylist}>
                  <View
                    style={{
                      height: 50,
                      paddingHorizontal: 16,
                      marginTop: 20,
                      backgroundColor: "#e8e8e8",
                      alignItems: "center",
                      justifyContent: "center"
                    }}>
                    <Text style={{ fontWeight: "700" }}>Load next playlist</Text>
                    <Text style={{ fontSize: 11, marginTop: 3 }}>
                      Current: playlist {this.state.pidx}
                    </Text>
                  </View>
                </TouchableOpacity>

                <TouchableOpacity onPress={this.onPressGetCurrentTrack}>
                  <View
                    style={{
                      height: 50,
                      paddingHorizontal: 16,
                      marginTop: 20,
                      backgroundColor: "#dfdfdf",
                      alignItems: "center",
                      justifyContent: "center"
                    }}>
                    <Text style={{ fontWeight: "700" }}>Get current track</Text>
                    <Text numberOfLines={1} style={{ fontSize: 11, marginTop: 3, width: 120, textAlign: 'center' }}>
                      {this.state.currentTrackTitle}
                    </Text>
                  </View>
                </TouchableOpacity>
              </View>
            </View>
          </View>
        </View>
      </View>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center"
  },
  welcome: {
    fontSize: 20,
    textAlign: "center",
    margin: 10
  },
  instructions: {
    textAlign: "center",
    color: "#333333",
    marginBottom: 5
  }
})
