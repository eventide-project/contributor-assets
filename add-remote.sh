#!/usr/bin/env bash

${DRY_RUN:=true}

set -e

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

source ./projects/projects.sh
source ./run-cmd.sh

working_copies=(
  "${projects[@]}"
)

function add-remote {
  name=$1

  remote_repository_url="$remote_url/$name.git"

  dir=$name
  pushd $dir > /dev/null

  if git remote | grep $remote_name > /dev/null; then
    echo "Working copy $name already has a remote named $remote_name. Skipping."
  else
    cmd="git remote add $remote_name $remote_repository_url"
    run-cmd "$cmd"
  fi

  popd > /dev/null
}

remote_name=$1
remote_url=$2

if [ -z "$remote_name" ] || [ -z "$remote_url" ]; then
  echo "Usage: add-remote.sh <remote name> <url authority and path (without repository name)>"
  exit
fi

echo
echo "Adding remote (Name: $remote_name, URI: $remote_url)"
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
    add-remote $name
  fi
  echo
done

popd > /dev/null

echo "= = ="
echo
