#!/usr/bin/env bash

set -e

clear

install_gems=true
if [ ! -z ${INSTALL_GEMS+x} ]; then
  if [ $INSTALL_GEMS = false ]; then
    install_gems=false
  fi
fi

echo
echo "Testing Eventide Utility Libraries"
echo "= = ="
echo "(Install Gems: $install_gems}"
echo

source ./projects/ruby-public-gem-projects.sh

# libraries=(
#   "${ruby_active_projects[@]}"
# )

libraries=(
  "schema"
)

pushd $PROJECTS_HOME > /dev/null

for name in "${libraries[@]}"; do
  echo
  echo
  echo
  echo $name
  echo "= = = = = = = = = = = = = = = = = = = = = = = = = ="

  dir=$name

  pushd $dir > /dev/null

  if [ $install_gems = true ]; then
    echo "- installing gems"

    if [ -d gems ]; then
      rm -rf gems
    fi

    if [ -d .bundle ]; then
      rm -rf .bundle
    fi

    if [ -f Gemfile.lock ]; then
      rm Gemfile.lock
    fi

    . ./install-gems.sh
  fi

  ruby test/automated.rb

  popd > /dev/null

  echo
done

popd > /dev/null
