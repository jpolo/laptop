#!/usr/bin/env bash

laptop_package_ensure__pack:kube-utils() {
  laptop_package_ensure "k9s"
  laptop_package_ensure "kubectl"
  laptop_package_ensure "kubectx"
}
