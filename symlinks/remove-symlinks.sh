#!/usr/bin/env bash

set -eu

function removeSymlinks() {
  local dir=${1:-$LIBRARIES_HOME}
  local entry

  for entry in $dir/*; do
    if [ ! -L $entry ]; then
      continue
    fi

    if [ -d $entry ]; then
      removeSymlinks $entry
    fi

    echo "- removing symlink $entry"
    rm -f $entry
  done
}

echo
echo "Removing symlinks"
echo "= = ="
echo
echo "Libraries Directory: $LIBRARIES_HOME"
echo

removeSymlinks
