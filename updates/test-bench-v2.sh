#!/usr/bin/env bash

set -eEu -o pipefail

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

echo
echo "Upgrading Ruby Projects to TestBench v2"
echo "= = ="
echo

read -r -d '' test_automated_rb <<'TEXT' || true
require_relative './test_init'

TestBench::Run.(
  'test/automated',
  exclude: '{_*,*sketch*,*_init,*_tests}.rb'
) or exit(false)
TEXT

pushd $PROJECTS_HOME > /dev/null

for project in ${ruby_public_gem_projects[@]}; do
  echo $project
  echo "- - -"

  pushd $project >/dev/null

  if [ ! -f test/automated.rb ]; then
    echo "Project doesn't have a test/automated.rb, skipping"
    read -r
    popd >/dev/null
    continue
  fi

  echo "$test_automated_rb" > test/automated.rb

  if [ $(git status --porcelain | wc -l) -eq "0" ]; then
    echo "Already updated"
  else
    rm -rf Gemfile.lock gems .bundle
    ./install-gems.sh

    if [ $(find test/automated -type f -not -name automated_init.rb | wc -l) -eq "0" ]; then
      echo "Project doesn't have any automated tests, skipping test/automated.rb"
      read -r
    else
      ruby test/automated.rb
    fi

    git add test/automated.rb

    git commit -m 'Automated test runner has been updated to be compatible with Test Bench v2'
    git push

    echo
    echo "$project is done. Press enter to continue"
    read -r
  fi

  echo

  popd > /dev/null
done

popd > /dev/null
