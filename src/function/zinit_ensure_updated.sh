#!/usr/bin/env bash

laptop_zinit_ensure_updated() {
  laptop_step_upgrade_start "zinit updated"
  laptop_step_eval "env zsh --login -i -c \"zinit update --all\""
}
