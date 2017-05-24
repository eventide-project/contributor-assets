#!/usr/bin/env bash

clear

set -e

if [ -z ${DRY_RUN+x} ]; then
  DRY_RUN=true
fi

echo
echo "Updating the Gem Installation Scripts for Ruby Projects"
echo "= = ="
echo

source ./projects/ruby-projects.sh
source ./update-file.sh

working_copies=(
  "${ruby_projects[@]}"
)

old_files=(
  "install-gems.sh"
  "set-local-gem-path.sh"
)

files=(
  "install_gems.sh"
  "set_local_gem_path.sh"
)

src_dir='contributor-assets'

pushd $PROJECTS_HOME > /dev/null

for name in "${working_copies[@]}"; do
  echo $name
  echo "- - -"

  dir=$name

  for file_name in "${old_files[@]}"; do
    if [ -f $dir/$file_name ]; then
      echo "Deleting $dir/$file_name"
      rm $dir/$file_name
    fi
  done

  for file_name in "${files[@]}"; do
    update-file $file_name $src_dir $dir
    echo
  done
done

popd > /dev/null
