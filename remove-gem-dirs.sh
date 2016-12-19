#!/usr/bin/env bash

echo "Removing Gem Installations"
echo

pushd $PROJECTS_HOME > /dev/null

for dir in *; do
  pushd $dir > /dev/null

  echo $dir
  echo "- - -"

  echo "Removing gems directory...";
  rm -rf gems;
  echo "Removing .bundle directory...";
  rm -rf .bundle;
  echo "Removing Gemfile.lock file...";
  rm Gemfile.lock;

  popd > /dev/null
  echo
done

popd > /dev/null

echo "= = ="
