import React from "react"
import { Platform, requireNativeComponent } from "react-native"
import PropTypes from "prop-types"
import { cleanProps } from "../propUtils"
import styles from "../styles"

const RNTrackTitle = requireNativeComponent("RNPlaylistTrackTitle", TrackTitle)

export default class TrackTitle extends React.Component {
  render() {
    return <RNTrackTitle {...cleanProps(this.props, styles.wrapper)} />
  }
}

TrackTitle.defaultProps = {
  marqueeSpeed: 60,
  marqueeDelay: 1.0,
  marqueeFadeLength: 50,
  marqueeTrailingMargin: 50
}
