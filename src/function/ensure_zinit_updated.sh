#!/usr/bin/env bash

laptop::ensure_zinit_updated() {
  laptop::step_start "- Upgrade zinit"
  laptop::step_eval "env zsh --login -i -c \"zinit update --all\""
}
