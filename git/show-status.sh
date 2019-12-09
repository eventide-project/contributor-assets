#!/usr/bin/env bash

set -e

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

echo
echo "Showing status for all projects"
echo "= = ="
echo

pushd $PROJECTS_HOME > /dev/null

for name in *; do
  echo $name
  echo "- - -"

  if [ ! -d "$name/.git" ]; then
    echo "Not a Git working copy. Skipping."
    echo
    continue
  fi

  dir=$name
  pushd $dir > /dev/null

  git status

  popd > /dev/null

  echo
  echo
done

popd > /dev/null

echo "= = ="
