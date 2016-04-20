#!/usr/bin/env bash

${DRY_RUN:=true}

set -e

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

if [ -z ${GIT_AUTHORITY_PATH+x} ]; then
  echo "GIT_AUTHORITY_PATH is not set"
  exit
fi

if [ -z ${REMOTE_NAME+x} ]; then
  echo "(REMOTE_NAME is not set. Using \"origin\" by default.)"
  remote_name="origin"
else
  remote_name=$REMOTE_NAME
fi

source ./projects/projects.sh

working_copies=(
  "${projects[@]}"
)

remote_authority_path=$GIT_AUTHORITY_PATH

function clone-repo {
  name=$1

  remote_repository_url="$remote_authority_path/$name.git"

  echo "Cloning: $remote_repository_url"
  echo "- - -"

  clone_cmd="git clone $remote_repository_url"

  if [ "$DRY_RUN" = "true" ]; then
    echo "DRY RUN $clone_cmd"
  else
    echo $clone_cmd
    ($clone_cmd)
  fi
}

function pull-repo {
  name=$1

  echo "Pulling: $name (master branch only)"
  echo "- - -"

  dir=$name
  pushd $dir > /dev/null

  checkout_cmd="git checkout master"
  pull_cmd="git pull --rebase $remote_name master"

  current_branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

  if [ master != $current_branch ]; then
    echo $checkout_cmd
    ($checkout_cmd)
  fi

  if [ "$DRY_RUN" = "true" ]; then
    echo "DRY RUN $pull_cmd"
  else
    echo $pull_cmd
    ($pull_cmd)
  fi

  if [ master != "$current_branch" ]; then
    co_crnt_cmd="git checkout $current_branch"
    echo $co_crnt_cmd
    ($co_crnt_cmd)
  fi

  popd > /dev/null
}

echo
echo "Getting code from $remote_authority_path"
echo "= = ="
echo

pushd $PROJECTS_HOME > /dev/null

for name in "${working_copies[@]}"; do
  if [ ! -d "$name/.git" ]; then
    clone-repo $name
  else
    pull-repo $name
  fi
  echo "= = ="
  echo
done

popd > /dev/null

echo "= = ="
echo "(done getting code)"

