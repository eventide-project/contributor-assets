#!/usr/bin/env bash

set -e

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

echo
echo "Showing current branch for all working copies"
echo "= = ="
echo

pushd $PROJECTS_HOME > /dev/null

not_master=()
for dir in *; do
  if [ ! -d "$dir/.git" ]; then
    continue
  fi

  pushd $dir > /dev/null

  current_branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

  working_copy="$dir: $current_branch"

  if [ master != $current_branch ]; then
    not_master+=("$working_copy")
    working_copy="$working_copy (!)"
  fi

  echo "$working_copy"

  popd > /dev/null
done

popd > /dev/null

echo
echo
echo "Working copies not on master"
echo "- - -"
echo

for name in "${not_master[@]}"; do
  echo "$name"
done

echo
