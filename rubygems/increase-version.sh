#!/usr/bin/env bash

${DRY_RUN:=true}

set -e

exec 1>&2

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

if [ -z ${LEVEL+x} ]; then
  echo "LEVEL is not set"
  exit
fi

source ./projects/ruby-public-gem-projects.sh
source ./utilities/run-cmd.sh

script_dir=$(pwd)

function increase-version {
  gemspec=$1
  level=$2

  increase_version_ruby_script="$script_dir/rubygems/increase_version.rb"

  versions=($(LEVEL=$level GEMSPEC=$gemspec ruby $increase_version_ruby_script))

  current_version=${versions[0]}
  next_version=${versions[1]}

  commit-changes $current_version $next_version
}

function commit-changes {
  current_version=$1
  next_version=$2

  add_cmd="git add ."
  run-cmd "$add_cmd"

  commit_message="Package version is increased from $current_version to $next_version"
  commit_cmd="git commit -m '$commit_message'"
  run-cmd "$commit_cmd"
}

echo
echo "Increase Version"
echo "= = ="
echo

__working_copies=(
  "${ruby_public_gem_projects[@]}"
)

working_copies=(
  "async-invocation"
)

____working_copies=(
  "attribute"
  "casing"
  "clock"
  "collection"
  "component-host"
  "configure"
  "consumer"
  "consumer-event-store"
  "consumer-postgres"
  "copy"
  "cycle"
  "dependency"
  "entity-cache"
  "entity-projection"
  "entity-snapshot-event-store"
  "entity-snapshot-postgres"
  "entity-store"
  "event-store-http"
  "eventide-postgres"
  "eventide-event-store"
  "identifier-uuid"
  "initializer"
  "log"
  "message-store"
  "message-store-event-store"
  "message-store-postgres"
  "messaging"
  "messaging-event-store"
  "messaging-postgres"
  "retry"
  "schema"
  "set-attributes"
  "settings"
  "subst-attr"
  "telemetry"
  "transform"
  "try"
  "validate"
  "virtual"
)

pushd $PROJECTS_HOME > /dev/null

for name in "${working_copies[@]}"; do
  echo $name
  echo "- - -"

  dir=$name
  pushd $dir > /dev/null

  for gemspec in *.gemspec; do
    increase-version $gemspec $LEVEL
  done

  popd > /dev/null

  echo
done

popd > /dev/null

echo "= = ="
