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
import { Platform, StyleSheet, Text, View } from 'react-native';
import Playlist, { Playbar } from 'react-native-playlist';

export default class App extends Component<{}> {
  state = {
    color: undefined
  }

  async componentDidMount() {

    setTimeout(() => {
      Playlist.setupPlayer()
      setTimeout(() => {
        Playlist.play()
      }, 2000)
    }, 3000)

    // setTimeout(() => {
    //   // Playlist.skipToNext()
    // }, 2000)
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>Playlist example☆</Text>
        <Text style={styles.instructions}>STATUS: loaded</Text>
        <Playbar 
          style={{
            width: "100%",
            backgroundColor: '#f0f0f0',
            height: 100
          }}
          theme={{
            trackPlayedColor: 'deepskyblue',
            trackRemainingColor: this.state.color
          }} />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
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
