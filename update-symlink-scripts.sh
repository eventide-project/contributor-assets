#!/usr/bin/env bash

${DRY_RUN:=true}

clear

set -e

echo
echo "Updating Symlink Scripts for Ruby Projects"
echo "= = ="
echo

source ./projects/ruby-projects.sh
source ./update-file.sh

working_copies=(
  "${ruby_projects[@]}"
)

file_name="library-symlinks.sh"

src_dir='contributor-assets'

pushd $PROJECTS_HOME > /dev/null

for name in "${working_copies[@]}"; do
  echo $name
  echo "- - -"
  dir=$name
  update-file $file_name $src_dir $dir
  echo
done

popd > /dev/null
