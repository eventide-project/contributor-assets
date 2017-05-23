#!/usr/bin/env bash

set -e

echo
echo "Archiving obsolete libraries"
echo "= = ="
echo

if [ -z ${DRY_RUN+x} ]; then
  DRY_RUN=true
fi

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

source ./projects/ruby-archived-projects.sh
source ./run-cmd.sh

working_copies=(
  "${ruby_archived_projects[@]}"
)

pushd $PROJECTS_HOME > /dev/null

if [ ! -d ".archive" ]; then
  echo "Creating archive directory for obsolete libraries"
  mkdir_cmd="mkdir .archive"
  run-cmd "$mkdir_cmd"
  echo
fi

for name in "${working_copies[@]}"
do
  echo "Archiving $name"

  if [ ! -d "$name" ]; then
    echo "$name not found in $PROJECTS_HOME. Skipping."
  else
    if [ -d ".archive/$name" ]; then
      echo ".archive/$name already exists. Already archived."
    else
      mv_cmd="mv $name/ .archive/$name/"
      run-cmd "$mv_cmd"
    fi
  fi

  echo
done

popd > /dev/null

echo "= = ="
