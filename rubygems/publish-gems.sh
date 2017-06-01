#!/usr/bin/env bash

set -e

if [ -z ${DRY_RUN+x} ]; then
  DRY_RUN=true
fi

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

function publish-gem {
  name=$1

  if test -n "$(find . -maxdepth 1 -name '*.gem' -print -quit)"; then
    for gem in *.gem; do
      echo "Removing $gem"
      rm_cmd="rm $gem"
      run-cmd "$rm_cmd"
    done
  else
    echo "(No gem files found)"
  fi

  for gemspec in *.gemspec; do
    echo "Building $gemspec"
    build_cmd="gem build $gemspec"
    run-cmd "$build_cmd"
  done

  for gemfile in *.gem; do
    echo "Publishing $gemfile"
    push_cmd="gem push $gemfile"
    run-cmd "$push_cmd"
  done
}

source ./projects/ruby-public-gem-projects.sh
source ./utilities/run-cmd.sh

# working_copies=(
#   "${ruby_public_gem_projects[@]}"
# )

working_copies=(
  "consumer"
  "consumer-event-store"
  "consumer-postgres"
  "entity-snapshot-event-store"
  "event-store-http"
  "messaging-event-store"
)

echo
echo "Publishing gems"
echo "= = ="
echo

pushd $PROJECTS_HOME > /dev/null

for name in "${working_copies[@]}"; do
  echo "$name"
  echo "- - -"

  dir=$name
  pushd $dir > /dev/null

  publish-gem $name

  popd > /dev/null

  echo
done

popd > /dev/null

echo "= = ="
