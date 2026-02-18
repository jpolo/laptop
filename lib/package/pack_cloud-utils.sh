#!/usr/bin/env bash

laptop_require "laptop_package_ensure"

laptop_package_ensure__pack:cloud-utils() {
  # Install devops / cloud provider
  laptop_package_ensure "az"       # Azure CLI
  laptop_package_ensure "heroku"   # Heroku CLI
  laptop_package_ensure "gcloud"   # Google Cloud CLI
  laptop_package_ensure "scalingo" # Scalingo CLI
  laptop_package_ensure "vercel-cli" # Vercel CLI
}
