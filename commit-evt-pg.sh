#!/usr/bin/env bash

echo "Renaming gemspecs"
echo

dirs=(
  "async-invocation"
  "attribute"
  "casing"
  "clock"
  "configure"
  "collection"
  "cycle"
  "dependency"
  "entity-cache"
  "entity-projection"
  "entity-store"
  "event-source"
  "event-source-postgres"
  "eventide-postgres"
  "identifier-uuid"
  "initializer"
  "log"
  "messaging"
  "messaging-postgres"
  "schema"
  "set-attributes"
  "settings"
  "subst-attr"
  "telemetry"
  "telemetry-logger"
  "transform"
  "validate"
  "virtual"
)

for dir in "${dirs[@]}"; do
  echo $dir
  echo "- - -"

  pushd $dir > /dev/null

  git add .
  git add . -u
  git commit -m 'Gems renamed to have evt prefix'
  git push origin master

  popd > /dev/null
  echo
done

echo "= = ="
