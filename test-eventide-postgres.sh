#!/usr/bin/env bash

set -e

clear

echo
echo "Testing Eventide Postgres Libraries"
echo "= = ="
echo

libraries=(
  "event-source"
  "event-source-postgres"
  "messaging"
  "messaging-postgres"
  "entity-projection"
  "entity-cache"
  "entity-store"
  "entity-store-postgres"
  "entity-snapshot-postgres"
)

install_gems=false
if [ -z ${INSTALL_GEMS+x} ]; then
  if [ $INSTALL_GEMS = true ]; then
    install_gems=true
  fi
fi

pushd $PROJECTS_HOME > /dev/null

for name in "${libraries[@]}"; do
  echo $name
  echo "- - -"

  dir=$name

  pushd $dir > /dev/null

  if [ $install_gems = true ]; then
    echo "- installing gems"
    rm -rf gems
    rm -rf .bundle
    rm Gemfile.lock

    . ./install-gems.sh
  fi

  ruby test/automated.rb

  popd > /dev/null

  echo
done

popd > /dev/null
