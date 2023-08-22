#!/usr/bin/env bash

set -eEuo pipefail

if [ -z ${DRY_RUN+x} ]; then
  DRY_RUN=true
fi

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

source utilities/update-file.sh
source utilities/run-cmd.sh
source utilities/sed.sh

source projects/ruby-public-gem-projects.sh

function update-gitignore {
  project=$1

  pushd $project

  sed-i -e '/\.bundle/d' -e '/Gemfile\.lock/d' .gitignore

  rm -rvf .bundle Gemfile.lock

  if [ -n "$(git status -s)" ]; then
    git add .gitignore
    git commit -m 'Bundler artifacts are removed from .gitignore'
  fi

  popd
}

echo
echo "Supplanting Bundler"
echo "= = ="
echo

pushd $PROJECTS_HOME > /dev/null

for project in ${ruby_public_gem_projects[@]}; do
  echo $project
  echo "- - -"

  #update-file "install-gems.sh" "contributor-assets/standardized" "$project"
  #update-file "load_path.rb" "contributor-assets/standardized" "$project"

  #update-gitignore "$project"

  #git -C "$project" push
done

popd > /dev/null
