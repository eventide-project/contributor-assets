#!/usr/bin/env bash

set -e

if [ -z ${DRY_RUN+x} ]; then
  DRY_RUN=false
fi

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

source ./projects/projects.sh
source ./utilities/run-cmd.sh

working_copies=(
  "${projects[@]}"
)

echo
echo "Projects status"
echo "= = ="
echo

pushd $PROJECTS_HOME > /dev/null

for name in "${working_copies[@]}"; do
  echo "$name"
  echo "- - -"

  dir=$name
  pushd $dir > /dev/null

  run-cmd "git status"

  popd > /dev/null

  echo
done

popd > /dev/null

echo "= = ="

