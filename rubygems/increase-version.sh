#!/usr/bin/env bash

${DRY_RUN:=true}

set -e

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

if [ -z ${LEVEL+x} ]; then
  echo "LEVEL is not set"
  exit
fi

source ./projects/ruby-public-gem-projects.sh
source ./utilities/run-cmd.sh

function increase-version {
  gemspec=$1
  level=$2

  echo "LEVEL=$level GEMSPEC=$gemspec ruby increase_version.rb"
}

echo
echo "Increase Version"
echo "= = ="
echo

working_copies=(
  "${ruby_public_gem_projects[@]}"
)

pushd $PROJECTS_HOME > /dev/null

for name in "${working_copies[@]}"; do
  echo $name
  echo "- - -"

  dir=$name
  pushd $dir > /dev/null

  for gemspec in *.gemspec; do
    increase-version $gemspec, $LEVEL
  done

  popd > /dev/null

  echo
done

popd > /dev/null

echo "= = ="
