#!/usr/bin/env bash

clear

set -e

if [ -z ${DRY_RUN+x} ]; then
  DRY_RUN=true
fi

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

if [ -z ${GEMFURY_TOKEN+x} ]; then
  echo "GEMFURY_TOKEN is not set"
  exit
fi

function publish-gems {
  if test -n "$(find . -maxdepth 1 -name '*.gem' -print -quit)"; then
    for gemfile in *.gem; do
      echo "Removing $gemfile"
      cmd="rm $gemfile"
      run-cmd "$cmd"
    done
  fi

  for gemspec in *.gemspec; do
    echo "Building $gemspec"
    cmd="gem build $gemspec"
    run-cmd "$cmd"
  done

  for gemfile in *.gem; do
    echo "Publishing $gemfile"
    cmd="curl -F package=@$gemfile https://$GEMFURY_TOKEN@push.fury.io/eventide/"
    run-cmd "$cmd"
  done
}

source ./projects/projects.sh
source ./run-cmd.sh

echo
echo "Publishing gems"
echo "= = ="
echo

# working_copies=(
#   "${projects[@]}"
# )

working_copies=(
  "attribute"
)

pushd $PROJECTS_HOME > /dev/null

for name in "${working_copies[@]}"; do
  echo $name
  echo "- - -"

  dir=$name
  pushd $dir > /dev/null

  publish-gems

  popd > /dev/null

  echo
done

popd > /dev/null

echo "= = ="
