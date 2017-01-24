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

pushd $PROJECTS_HOME > /dev/null

for name in "${libraries[@]}"; do
  echo $name
  echo "- - -"

  dir=$name

  pushd $dir > /dev/null

  ruby test/automated.rb

  popd > /dev/null

  echo
done

popd > /dev/null
