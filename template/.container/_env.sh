#!/usr/bin/env bash
set -euo pipefail

export ENVIRONMENT=${ENVIRONMENT:-development}
export NODE_ENV=${NODE_ENV:-$ENVIRONMENT}
export RAILS_ENV=${RAILS_ENV:-$ENVIRONMENT}
export BUILD_TYPE=${BUILD_TYPE:-debug}
export PORT=${PORT:-3000}

# Active Jemalloc (ram usage)
export LD_PRELOAD="libjemalloc.so.2"

# The entry to launch in the Procfile (optional)
export FOREMAN_PROCESS=${FOREMAN_PROCESS:-""}

# Set RUBY_DEBUG_OPEN
if [[ "$BUILD_TYPE" = "debug" ]];then
  export RUBY_DEBUG_OPEN=true
fi

# Set RACK_ENV on build type "release"
if [[ "$BUILD_TYPE" = "debug" ]];then
  export RACK_ENV=${RACK_ENV:-development}
else
  export RACK_ENV=${RACK_ENV:-deployment}
fi
