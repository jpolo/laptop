#!/usr/bin/env zsh

if [ "$LAPTOP_DEVCONTAINER" = "false" ];then
  laptop_handler_call "login"
fi
