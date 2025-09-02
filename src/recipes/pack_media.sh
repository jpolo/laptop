#!/usr/bin/env bash

# Pack to manipulate photo, videos and other media
laptop::ensure_package__pack:media() {
  laptop::ensure_package "excalidrawz"
  laptop::ensure_package "inkscape"
  laptop::ensure_package "gimp"
  laptop::ensure_package "openshot-video-editor"
}
