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
echo "Testing Active Libraries"
echo "= = ="
echo "(Install Gems: $install_gems}"
echo

source ./projects/ruby-public-gem-projects.sh

libraries=(
  "${ruby_active_projects[@]}"
)

pushd $PROJECTS_HOME > /dev/null

for name in "${libraries[@]}"; do
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

  if [ -f test/automated.rb ]; then
    ruby test/automated.rb
  elif [ -f ./test.sh ]; then
    ./test.sh
  else
    echo "- no tests to run"
  fi

  popd > /dev/null

  echo
done

popd > /dev/null
