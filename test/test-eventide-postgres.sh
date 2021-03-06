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
echo "Testing Eventide Postgres Libraries"
echo "= = ="
echo "(Install Gems: $install_gems}"
echo

libraries=(
  "message-store"
  "message-store-postgres"
  "messaging"
  "messaging-postgres"
  "entity-projection"
  "entity-cache"
  "entity-store"
  "entity-store-postgres-test"
  "entity-snapshot-postgres"
  "consumer-postgres"
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
