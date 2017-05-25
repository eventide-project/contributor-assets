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

function run-cmd {
  cmd=$1

  if [ "$DRY_RUN" = "true" ]; then
    echo "(DRY RUN) $cmd"
  else
    echo "$cmd"
  fi

  if [ "$DRY_RUN" != "true" ]; then
    ($cmd)
  fi
}

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

for dir in *; do
  echo "$dir"
  echo "- - -"

  dir=$dir
  pushd $dir > /dev/null

  if [ ! -d ".git" ]; then
    echo "$dir is not a git working copy. Skipping."
    echo
  else
    push-project $dir
  fi

  popd > /dev/null

  echo
done

echo "= = ="

