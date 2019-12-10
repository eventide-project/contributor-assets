#!/usr/bin/env bash

set -e

if [ -z ${DRY_RUN+x} ]; then
  DRY_RUN=true
fi

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit 1
fi

if [ -z ${GENERATION+x} ]; then
  echo "GENERATION is not set"
  exit 1
fi

source ./projects/ruby-public-gem-projects.sh
source ./utilities/run-cmd.sh

script_dir=$(pwd)

function set-generation {
  gemspec=$1

  set_generation_ruby_script="$script_dir/rubygems/set_generation.rb"

  versions=($(GEMSPEC=$gemspec ruby $set_generation_ruby_script))

  if [[ ! -z ${versions[*]} ]]; then
    current_version=${versions[0]}
    next_version=${versions[1]}

    commit-changes $current_version $next_version
  fi
}

function commit-changes {
  current_version=$1
  next_version=$2

  add_cmd="git add ."
  run-cmd "$add_cmd"

  commit_message="Package version is increased from $current_version to $next_version"
  commit_cmd="git commit -m '$commit_message'"
  run-cmd "$commit_cmd"
}

echo
echo "Set Generation"
echo "= = ="
echo

# working_copies=(
#   "${ruby_utility_projects[@]}"
# )

working_copies=(
  "async-invocation"
  "attribute"
)

pushd $PROJECTS_HOME > /dev/null

for name in "${working_copies[@]}"; do
  echo $name
  echo "- - -"

  dir=$name
  pushd $dir > /dev/null

  for gemspec in *.gemspec; do
    set-generation $gemspec
  done

  popd > /dev/null

  echo
done

popd > /dev/null
