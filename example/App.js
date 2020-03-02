/**
 * Sample React Native App
 *
 * adapted from App.js generated by the following command:
 *
 * react-native init example
 *
 * https://github.com/facebook/react-native
 */

import React, { Component } from 'react';
import { Platform, TouchableOpacity, Dimensions, StyleSheet, Text, View } from 'react-native';
import Playlist, { PlaylistEventEmitter, EventTypes, PlaylistComponent } from 'react-native-playlist';

const { width: deviceWidth, height: deviceHeight } = Dimensions.get('window')
const tracklistJSON = require('./data/hiphop_playlist_full.json')

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

const playerTracks = tracklistJSON.tracks.data.slice(1, 3).map(t => ({
  url: t.preview,
  title: t.title,
  artwork: t.album.cover_big,
  album: t.album.title,
  artist: t.artist.name,
  custom: {
    foo: "any extra data here",
    bar: ["a", "b", "c"],
  }
}))

const playerTracks2 = tracklistJSON.tracks.data.slice(4, 6).map(t => ({
  url: t.preview,
  title: t.title,
  artwork: t.album.cover_big,
  album: t.album.title,
  artist: t.artist.name,
  custom: {
    foo: "any extra data here",
    bar: ["a", "b", "c"],
  }
}))

export default class App extends Component<{}> {
  state = {
    playlistId: 1,
    color1: 'teal',
    trackTitle: 'N/A'
  }

  async componentDidMount() {
    Playlist.setup({
      enableEvents: false,
      enableCache: false,
      enableLogs: false
    })

    Playlist.addTracks(playerTracks)

    // Add Listener
    PlaylistEventEmitter.addListener(EventTypes.onTrackChange, track => {
      console.log('track', track)
      this.setState({ trackTitle: track?.title })
    })
  }

  onPressLoadNextPlaylist = () => {
    const playlistId = this.state.playlistId === 1 ? 2 : 1
    this.setState({ playlistId })
    Playlist.addTracks(playlistId === 1 ? playerTracks : playerTracks2)
  }

  render() {
    return (
      <View style={styles.container}>
        <View style={{ flex: 1, width: '100%' }}>
          <View style={{ flex: 1, backgroundColor: '#e0e0e0' }} >
            <TrackAlbumArt style={{ width: deviceHeight/2, height: deviceHeight/2 }} />
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
            <View style={{
              marginTop: 15,
              marginBottom: 60,
            }}>
              <TrackTitle
                fontFamily={'Avenir-Heavy'}
                fontSize={23}
                color={"#222"}
                textAlign={"center"}
                style={{ minHeight: 30, marginBottom: 5, marginTop: 20, marginHorizontal: 50 }} />
              <TrackArtist 
                fontFamily={'Monaco'}
                fontSize={19}
                color={"#666"}
                textAlign={"center"}
                style={{ minHeight: 30 }} />
            </View>
            <View style={{ flexDirection: 'row', marginTop: 20, alignItems: 'space-around' }}>
              <TrackProgress
                fontFamily={'Avenir-Heavy'}
                fontSize={15}
                color={'lightgray'}
                textAlign={"center"}
                style={{ minHeight: 50 }}
                />
              <SkipPrev
                disabledOpacity={0.4}
                icon={"previous.png"}
                color={'#444'} 
                style={{
                  flex: 0,
                  width: 28,
                  height: 28,
                }}/>
              <PlayPause
                playIcon={"play-circle.png"}
                pauseIcon={"pause-circle.png"} 
                color={'#222'} 
                style={{
                  flex: 0,
                  width: 50,
                  marginHorizontal: 35,
                }}/>
              <SkipNext 
                disabledOpacity={0.4}
                icon={"next.png"}
                color={'#444'}
                style={{
                  flex: 0,
                  width: 28,
                  height: 28
                }} />
              <TrackDuration 
                fontFamily={'Avenir-Heavy'}
                fontSize={15}
                color={'lightgray'}
                textAlign={"center"}
                style={{ minHeight: 50 }} />
            </View>
            <View style={{ justifyContent: 'center', alignItems: 'center' }}>
              <Text style={{ fontWeight: '600', textAlign: 'center', marginTop: 40 }}>Current track title from PlaylistEventEmitter:</Text>
              <Text style={{ textAlign: 'center'}}>{this.state.trackTitle}</Text>

              <TouchableOpacity onPress={this.onPressLoadNextPlaylist}>
                <View style={{ height: 40, paddingHorizontal: 16, marginTop: 20, backgroundColor: '#e8e8e8', alignItems: 'center', justifyContent: 'center' }}>
                  <Text>Load next playlist</Text>
                </View>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center'
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
