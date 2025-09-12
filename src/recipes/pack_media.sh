#!/usr/bin/env bash

# Pack to manipulate photo, videos and other media
laptop_ensure_package__pack:media() {
  laptop_ensure_package "excalidrawz"
  laptop_ensure_package "inkscape"
  laptop_ensure_package "gimp"
  laptop_ensure_package "openshot-video-editor"
}
