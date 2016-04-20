#!/usr/bin/env bash

set -e

if [ -z ${DRY_RUN+x} ]; then
  DRY_RUN=true
fi

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

source ./projects/projects.sh
source ./run-cmd.sh

working_copies=(
  "${projects[@]}"
)

function remove-remote {
  name=$1

  dir=$name
  pushd $dir > /dev/null

  if git remote | grep $remote_name > /dev/null; then
    cmd="git remote rm $remote_name"
    run-cmd "$cmd"
  else
    echo "Working copy $name does not have a remote named $remote_name. Skipping."
  fi

  popd > /dev/null
}

remote_name=$1

if [ -z "$remote_name" ]; then
  echo "Usage: remove-remote.sh <remote name>"
  exit
fi

echo
echo "Removing remote (Name: $remote_name)"
echo "= = ="
echo

pushd $PROJECTS_HOME > /dev/null

for name in "${working_copies[@]}"; do
  echo $name
  echo "- - -"
  if [ ! -d "$name/.git" ]; then
    echo "$name is not a git working copy. Skipping."
    echo
  else
    remove-remote $name
  fi
  echo
done

popd > /dev/null

echo "= = ="
echo
