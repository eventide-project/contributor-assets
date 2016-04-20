#!/usr/bin/env bash

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
  cmd="rm *.gem"
  run-cmd "$cmd"
  echo

  for gemspec in *.gemspec; do
    echo "Building $gemspec"
    cmd="gem build $gemspec"
    run-cmd "$cmd"
    echo
  done

  for gemfile in *.gem; do
    echo "- publishing $gemfile"
    cmd="curl -F package=@$gemfile https://$GEMFURY_TOKEN@push.fury.io/eventide/"
    run-cmd "$cmd"
    echo
  done
}

source ./projects/projects.sh
source ./run-cmd.sh

echo
echo "Publishing gems"
echo "= = ="
echo

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
