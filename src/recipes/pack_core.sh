#!/usr/bin/env bash

laptop::ensure_package__pack:core() {
  # A pack of required packages

  # Install core tools
  laptop::ensure_package "coreutils"
  laptop::ensure_package "moreutils"
  laptop::ensure_package "findutils"
  laptop::ensure_package "asdf"
  laptop::ensure_package "curl"
  laptop::ensure_package "git"
  laptop::ensure_package "gnutls"
  laptop::ensure_package "gnupg"
  laptop::ensure_package "mercurial"
  laptop::ensure_package "gpg"
  laptop::ensure_package "jq"
  laptop::ensure_package "rclone"
  laptop::ensure_package "webp"
  laptop::ensure_package "wget"

  # Install library
  laptop::ensure_package "graphviz"
  laptop::ensure_package "imagemagick"
  laptop::ensure_package "libpq"
  laptop::ensure_package "libyaml"
  laptop::ensure_package "libvips"
  laptop::ensure_package "openssl"

  # Install ASDF plugins
  laptop::ensure_asdf_plugin "java" "https://github.com/halcyon/asdf-java.git"
  laptop::ensure_asdf_plugin "ruby" "https://github.com/asdf-vm/asdf-ruby.git"
  laptop::ensure_asdf_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
  laptop::ensure_asdf_plugin "python"

  # Hashicorp
  laptop::ensure_asdf_plugin "boundary" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop::ensure_asdf_plugin "consul" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop::ensure_asdf_plugin "levant" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop::ensure_asdf_plugin "nomad" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop::ensure_asdf_plugin "packer" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop::ensure_asdf_plugin "sentinel" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop::ensure_asdf_plugin "serf" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop::ensure_asdf_plugin "terraform" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop::ensure_asdf_plugin "terraform-ls" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop::ensure_asdf_plugin "tfc-agent" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop::ensure_asdf_plugin "vault" "https://github.com/asdf-community/asdf-hashicorp.git"
  laptop::ensure_asdf_plugin "waypoint" "https://github.com/asdf-community/asdf-hashicorp.git"

  # Cloud, Kubernetes, ...
  laptop::ensure_asdf_plugin "azure-cli" "https://github.com/itspngu/asdf-azure-cli"
  laptop::ensure_asdf_plugin "duckdb" "https://github.com/asdf-community/asdf-duckdb.git"
  laptop::ensure_asdf_plugin "helm" "https://github.com/Antiarchitect/asdf-helm.git"
  laptop::ensure_asdf_plugin "kubectl" "https://github.com/asdf-community/asdf-kubectl.git"
  laptop::ensure_asdf_plugin "kustomize" "https://github.com/Banno/asdf-kustomize.git"
  # laptop::ensure_asdf_plugin "cocoapods" "https://github.com/ronnnnn/asdf-cocoapods.git" Removed because not working so well, prefer a Gemfile/Gemfile.lock
  laptop::ensure_asdf_plugin "gcloud" "https://github.com/jthegedus/asdf-gcloud"
}
