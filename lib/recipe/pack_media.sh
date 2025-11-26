#!/usr/bin/env bash

# Pack to manipulate photo, videos and other media
laptop_package_ensure__pack:media() {
  laptop_package_ensure "excalidrawz"
  laptop_package_ensure "inkscape"
  laptop_package_ensure "gimp"
  # laptop_package_ensure "openshot-video-editor" Not really useful at the moment
}
