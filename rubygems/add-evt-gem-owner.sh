#!/usr/bin/env bash

gems=(
  "async_invocation"
  "attribute"
  "casing"
  "clock"
  "configure"
  "collection"
  "cycle"
  "dependency"
  "entity_cache"
  "entity_projection"
  "entity_snapshot-postgres"
  "entity_snapshot-event_store"
  "entity_store"
  "eventide-postgres"
  "eventide-event_store"
  "identifier-uuid"
  "initializer"
  "log"
  "message_store"
  "message_store-postgres"
  "message_store-event_store"
  "messaging"
  "messaging-postgres"
  "messaging-event_store"
  "schema"
  "set_attributes"
  "settings"
  "subst_attr"
  "telemetry"
  "telemetry-logger"
  "transform"
  "validate"
  "virtual"
)

if [ -z ${DRY_RUN+x} ]; then
  DRY_RUN=true
fi

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

function run-cmd {
  cmd=$1

  if [ "$DRY_RUN" = "true" ]; then
    msg="(DRY RUN) $cmd"
    echo $msg
  else
    echo "$cmd"
  fi

  if [ "$DRY_RUN" != "true" ]; then
    ($cmd)
  fi
}

owner=$1
if [ -z "$owner" ]; then
  echo "Usage: add-evt-gem-owner.sh <owner email address>"
  exit
fi

echo
echo "Adding owner to gems: $owner"
echo "= = ="
echo

for gemname in "${gems[@]}"; do
  evt_gemname="evt-$gemname"
  echo $evt_gemname
  echo "- - -"

  echo "gem owner $evt_gemname -a $owner"
  gem owner $evt_gemname -a $owner

  echo
done

echo "= = ="




