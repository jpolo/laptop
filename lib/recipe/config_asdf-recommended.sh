#!/usr/bin/env bash

laptop_require "laptop_asdf_ensure_plugin"

laptop_package_ensure__config:asdf-recommended() {

  # Install ASDF plugins
  laptop_asdf_ensure_plugin "java" "https://github.com/halcyon/asdf-java.git"
  laptop_asdf_ensure_plugin "ruby" "https://github.com/asdf-vm/asdf-ruby.git"
  laptop_asdf_ensure_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
  laptop_asdf_ensure_plugin "python"

  # Hashicorp
  laptop_asdf_ensure_plugin "boundary" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_asdf_ensure_plugin "consul" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_asdf_ensure_plugin "levant" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_asdf_ensure_plugin "nomad" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_asdf_ensure_plugin "packer" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_asdf_ensure_plugin "sentinel" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_asdf_ensure_plugin "serf" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_asdf_ensure_plugin "terraform" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_asdf_ensure_plugin "terraform-ls" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_asdf_ensure_plugin "tfc-agent" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_asdf_ensure_plugin "vault" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_asdf_ensure_plugin "waypoint" "https://github.com/asdf-community/asdf-hashicorp.git"

  # Cloud, Kubernetes, ...
  laptop_asdf_ensure_plugin "azure-cli" "https://github.com/itspngu/asdf-azure-cli"
  laptop_asdf_ensure_plugin "duckdb" "https://github.com/asdf-community/asdf-duckdb.git"
  laptop_asdf_ensure_plugin "helm" "https://github.com/Antiarchitect/asdf-helm.git"
  laptop_asdf_ensure_plugin "kubectl" "https://github.com/asdf-community/asdf-kubectl.git"
  laptop_asdf_ensure_plugin "kustomize" "https://github.com/Banno/asdf-kustomize.git"
  # laptop_asdf_ensure_plugin "cocoapods" "https://github.com/ronnnnn/asdf-cocoapods.git" Removed because not working so well, prefer a Gemfile/Gemfile.lock
  laptop_asdf_ensure_plugin "gcloud" "https://github.com/jthegedus/asdf-gcloud"
}
