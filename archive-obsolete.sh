#!/usr/bin/env bash

set -e

obsolete_projects=(
)

if [ -z ${DRY_RUN+x} ]; then
  DRY_RUN=true
fi

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

function archive-project {
  name=$1

  create_cmd="hub create evt-archive/$name"
  run-cmd "$create_cmd"

  add_remote_cmd="git remote add archive git@github.com:evt-archive/$name.git"
  run-cmd "$add_remote_cmd"

  push_cmd="git push archive master"
  run-cmd "$push_cmd"
}

source ./projects/projects.sh
source ./run-cmd.sh

echo
echo "Archiving Obsolete Projects"
echo "= = ="
echo

pushd $PROJECTS_HOME > /dev/null

for name in "${obsolete_projects[@]}"; do
  echo "$name"
  echo "- - -"

  dir=$name
  pushd $dir > /dev/null

  if [ ! -d ".git" ]; then
    echo "$dir is not a git working copy. Skipping."
    echo
  else
    archive-project $name
  fi

  popd > /dev/null

  echo
done

popd > /dev/null

echo "= = ="

