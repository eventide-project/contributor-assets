#!/usr/bin/env bash

set -e

if [ -z ${DRY_RUN+x} ]; then
  DRY_RUN=true
fi

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

function commit-project {
  name=$1

  cmd="git add ."
  run-cmd "$cmd"

  cmd="git add . -u"
  run-cmd "$cmd"

  cmd="git commit -m $commit_message"
  if [ "$DRY_RUN" = "true" ]; then
    echo "(DRY RUN) $cmd"
  else
    echo "$cmd"
    git commit -m "$commit_message" || true
  fi
}

source ./contributor-assets/run-cmd.sh

commit_message=$1
if [ -z "$commit_message" ]; then
  echo "Usage: commit-projects.sh <commit message>"
  exit
fi

echo
echo "Committing projects projects to $remote_name"
echo "= = ="
echo

echo "Commit message: $commit_message"
echo

pushd $PROJECTS_HOME > /dev/null

for dir in *; do
  echo "$dir"
  echo "- - -"

  dir=$dir
  pushd $dir > /dev/null

  if [ ! -d ".git" ]; then
    echo "$dir is not a git working copy. Skipping."
    echo
  else
    commit-project $dir
  fi

  popd > /dev/null

  echo
done

popd > /dev/null

echo "= = ="

