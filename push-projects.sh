#!/usr/bin/env bash

set -e

if [ -z ${DRY_RUN+x} ]; then
  DRY_RUN=true
fi

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

function push-project {
  name=$1

  push_cmd="git push $remote_name $branch_name:$branch_name"
  run-cmd "$push_cmd"
}

source ./projects/projects.sh
source ./run-cmd.sh

working_copies=(
  "${projects[@]}"
)

remote_name=$1
if [ -z "$remote_name" ]; then
  echo "(The remote name was not specified as the first argument to this script. Using \"origin\" by default.)"
  remote_name="origin"
fi

branch_name=$2
if [ -z "$branch_name" ]; then
  echo "(The branch name was not specified as the second argument to this script. Using \"master\" by default.)"
  branch_name="master"
fi

echo
echo "Pushing projects to $remote_name"
echo "= = ="
echo

pushd $PROJECTS_HOME > /dev/null

for name in "${working_copies[@]}"; do
  echo "$name"
  echo "- - -"

  dir=$name
  pushd $dir > /dev/null

  if [ ! -d ".git" ]; then
    echo "$dir is not a git working copy. Skipping."
    echo
  else
    push-project $name
  fi

  popd > /dev/null

  echo
done

popd > /dev/null

echo "= = ="

