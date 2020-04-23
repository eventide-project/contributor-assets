#!/usr/bin/env bash

set -eu

function buildGem() {
  local gemspec=$1
  local symlinks

  echo
  echo "Building gem: $gemspec"
  echo "= = ="
  echo

  gem build $gemspec

  echo
}

eval "$(dirname $BASH_SOURCE)/symlinks/remove-symlinks.sh"

for gem in *.gemspec; do
  buildGem $gem
done
