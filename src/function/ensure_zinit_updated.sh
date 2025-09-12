#!/usr/bin/env bash

laptop_ensure_zinit_updated() {
  laptop_step_start "- Upgrade zinit"
  laptop_step_eval "env zsh --login -i -c \"zinit update --all\""
}
