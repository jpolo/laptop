#!/usr/bin/env bash

## Screen Dimensions
# Find current screen size
if [ -z "${COLUMNS}" ]; then
   #COLUMNS=$(stty size)
   #COLUMNS=${COLUMNS##* }
   COLUMNS=80
fi

# When using remote connections, such as a serial port, stty size returns 0
if [ "${COLUMNS}" = "0" ]; then
   COLUMNS=80
fi
COL=$((${COLUMNS} - 8))
SET_COL="\\033[${COL}G"
NORMAL="\\033[0;39m"
SUCCESS="\\033[1;32m"
BRACKET="\\033[1;34m"

log_info_msg()
{
    echo -n -e "${@}"
    return 0
}

log_success_msg()
{
    echo -n -e "${@}"
    echo -e "${SET_COL}${BRACKET}[${SUCCESS}  OK  ${BRACKET}]${NORMAL}"
    return 0
}

log_failure_msg()
{
    echo -n -e "${@}"
    echo -e "${SET_COL}${BRACKET}[${FAILURE} FAIL ${BRACKET}]${NORMAL}"
    return 0
}

check_ansible()
{
  if [ -x "$(command -v ansible)" ] ; then
    return 0
  else
    return 1
  fi
}

install_ansible_deb()
{
  sudo apt install -qq software-properties-common && \
  sudo apt-add-repository -y -u ppa:ansible/ansible && \
  sudo apt install -qq ansible
}

install_ansible_macos()
{
  # Install XCode
  if ! [ -x "$(command -v gcc)" ]; then
    xcode-select --install
  fi

  # Install Homebrew
  if ! [ -x "$(command -v brew)" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  check_ansible || brew install ansible
}

install_ansible_all()
{
  if ! command -v apt &> /dev/null; then
    install_ansible_deb
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_ansible_macos
  else
    return 1
  fi
}

install_ansible()
{
  # 1. Try to install
  local installation_message="* Install ansible executable"
  if [ -z check_ansible ];then
    log_success_msg "$installation_message"
  else
    install_ansible_all && \
    log_success_msg "$installation_message" || \
    log_failure_msg "$installation_message";
  fi;

  # 2. Check installation
  check_ansible && \
  log_success_msg "$check_message" || \
  log_failure_msg "$check_message"
}
