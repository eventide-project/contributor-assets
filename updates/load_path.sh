#!/usr/bin/env bash

set -eu

if [ -z ${DRY_RUN+x} ]; then
  DRY_RUN=true
fi

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

source utilities/update-file.sh
source utilities/run-cmd.sh

source projects/ruby-public-gem-projects.sh

working_copies=(
  "${ruby_public_gem_projects[@]}"
)

echo
echo "Updating load_path.rb"
echo "= = ="
echo

pushd $PROJECTS_HOME > /dev/null

for project in ${working_copies[@]}; do
  echo $project
  echo "- - -"

  update-file "load_path.rb" "contributor-assets/standardized" "$project"

  echo
done

popd > /dev/null
