#!/usr/bin/env bash

set -eu

function buildGem() {
  local gemspec=$1

  echo
  echo "Building gem: $gemspec"
  echo "= = ="
  echo

  removeSymlinks $LIBRARIES_HOME

  gem build $gemspec

  echo
}

function removeSymlinks() {
  local dir=$1
  local entry;

  for entry in $dir/*; do
    if [ ! -L $entry ]; then
      continue
    fi

    if [ -d $entry ]; then
      removeSymlinks $entry
    fi

    echo "- removing symlink: $entry"
    rm -f $entry
  done
}

for gem in *.gemspec; do
  buildGem $gem
done
