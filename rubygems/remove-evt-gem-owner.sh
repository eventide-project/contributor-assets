#!/usr/bin/env bash

gems=(
  "async-invocation"
  "attribute"
  "casing"
  "clock"
  "collection"
  "command-line-component-generator"
  "cycle"
  "component-host"
  "consumer"
  "consumer-event-store"
  "consumer-postgres"
  "dependency"
  "entity-cache"
  "entity-projection"
  "entity-projection-fixtures"
  "entity-snapshot-postgres"
  "entity-store"
  "eventide"
  "eventide-postgres"
  "identifier-uuid"
  "initializer"
  "invocation"
  "log"
  "message-store"
  "message-store-postgres"
  "messaging"
  "messaging-fixtures"
  "messaging-postgres"
  "mimic"
  "pg-stats"
  "poll"
  "protocol"
  "record-invocation"
  "reflect"
  "retry"
  "schema"
  "schema-fixtures"
  "set-attributes"
  "settings"
  "subst-attr"
  "telemetry"
  "template-method"
  "transform"
  "try"
  "validate"
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
  echo "Usage: remove-evt-gem-owner.sh owner email address"
  exit
fi

source ./utilities/run-cmd.sh

echo
echo "Removing owner from gems: $owner"
echo "= = ="
echo

for gemname in "${gems[@]}"; do
  evt_gemname="evt-$gemname"
  echo $evt_gemname
  echo "- - -"

  cmd="gem owner $evt_gemname --remove $owner"
  run-cmd "$cmd"

  echo
done

echo "= = ="
