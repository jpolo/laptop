#!/usr/bin/env bash

laptop_ensure_package__pack:core() {
  # A pack of required packages

  # Install core tools
  laptop_ensure_package "coreutils"
  laptop_ensure_package "moreutils"
  laptop_ensure_package "findutils"
  laptop_ensure_package "asdf"
  laptop_ensure_package "curl"
  laptop_ensure_package "git"
  laptop_ensure_package "gnutls"
  laptop_ensure_package "gnupg"
  laptop_ensure_package "mercurial"
  laptop_ensure_package "gpg"
  laptop_ensure_package "jq"
  laptop_ensure_package "rclone"
  laptop_ensure_package "webp"
  laptop_ensure_package "wget"

  # Install library
  laptop_ensure_package "graphviz"
  laptop_ensure_package "imagemagick"
  laptop_ensure_package "libpq"
  laptop_ensure_package "libyaml"
  laptop_ensure_package "libvips"
  laptop_ensure_package "openssl"

  # Install ASDF plugins
  laptop_ensure_asdf_plugin "java" "https://github.com/halcyon/asdf-java.git"
  laptop_ensure_asdf_plugin "ruby" "https://github.com/asdf-vm/asdf-ruby.git"
  laptop_ensure_asdf_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
  laptop_ensure_asdf_plugin "python"

  # Hashicorp
  laptop_ensure_asdf_plugin "boundary" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_ensure_asdf_plugin "consul" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_ensure_asdf_plugin "levant" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_ensure_asdf_plugin "nomad" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_ensure_asdf_plugin "packer" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_ensure_asdf_plugin "sentinel" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_ensure_asdf_plugin "serf" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_ensure_asdf_plugin "terraform" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_ensure_asdf_plugin "terraform-ls" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_ensure_asdf_plugin "tfc-agent" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_ensure_asdf_plugin "vault" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop_ensure_asdf_plugin "waypoint" "https://github.com/asdf-community/asdf-hashicorp.git"

  # Cloud, Kubernetes, ...
  laptop_ensure_asdf_plugin "azure-cli" "https://github.com/itspngu/asdf-azure-cli"
  laptop_ensure_asdf_plugin "duckdb" "https://github.com/asdf-community/asdf-duckdb.git"
  laptop_ensure_asdf_plugin "helm" "https://github.com/Antiarchitect/asdf-helm.git"
  laptop_ensure_asdf_plugin "kubectl" "https://github.com/asdf-community/asdf-kubectl.git"
  laptop_ensure_asdf_plugin "kustomize" "https://github.com/Banno/asdf-kustomize.git"
  # laptop_ensure_asdf_plugin "cocoapods" "https://github.com/ronnnnn/asdf-cocoapods.git" Removed because not working so well, prefer a Gemfile/Gemfile.lock
  laptop_ensure_asdf_plugin "gcloud" "https://github.com/jthegedus/asdf-gcloud"
}
