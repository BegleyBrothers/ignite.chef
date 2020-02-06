#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright:: 2020, Begley Brothers.
#
# Execute cleanup logic only if the container is stopped explicitly.
# If you wish it to run cleanup when an underlying process/command stops by
# itself (or fails):
# 
# 1. uncomment the second trap syntax: trap 'true' SIGTERM
# 2. uncomment the final line: `cleanup`.

#Define cleanup procedure
cleanup() {
    echo "Container stopped, performing cleanup..."
    rm -rf /app/vendor
}

# Only run cleanup() when we trap SIGTERM
trap 'cleanup' SIGTERM

#Run cleanup() at the end of the script Trap SIGTERM
#trap 'true' SIGTERM

#Execute a command
"${@}" &


if [[ -t "$fd" || -p /dev/stdin ]]
then
  echo interactive
else
  echo non-interactive
fi

exec "bundle exec $@"
#Wait
wait $!

#Run cleanup here (always on exiting) if we use `trap 'true' SIGTERM`
#cleanup