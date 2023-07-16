#!/usr/bin/env bash

gems=(
  "async_invocation"
  "attribute"
  "casing"
  "clock"
  "configure"
  "collection"
  "command_line-component_generator"
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
  "mimic"
  "poll"
  "schema"
  "set_attributes"
  "settings"
  "subst_attr"
  "telemetry"
  "telemetry-logger"
  "transform"
  "validate"
  "view_data-commands"
  "view_data-pg"
  "virtual"
)

if [ -z ${DRY_RUN+x} ]; then
  DRY_RUN=true
fi

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

owner=$1
if [ -z "$owner" ]; then
  echo "Usage: add-evt-gem-owner.sh <owner email address>"
  exit
fi

source ./utilities/run-cmd.sh

echo
echo "Adding owner to gems: $owner"
echo "= = ="
echo

for gemname in "${gems[@]}"; do
  evt_gemname="evt-$gemname"
  echo $evt_gemname
  echo "- - -"

  add_cmd="gem owner $evt_gemname -a $owner"
  run-cmd "$add_cmd"

  echo
done

echo "= = ="
