#!/usr/bin/env bash

${DRY_RUN:=true}

clear

set -e

echo
echo "Updating the Gem Installation Scripts for Ruby Projects"
echo "= = ="
echo

source ./projects/ruby-projects.sh
source ./update-file.sh

working_copies=(
  "${ruby_projects[@]}"
)

files=(
  "install-gems.sh"
  "set-local-gem-path.sh"
)

src_dir='contributor-assets'

pushd $PROJECTS_HOME > /dev/null

for name in "${working_copies[@]}"; do
  echo $name
  echo "- - -"
  dir=$name
  for file_name in "${files[@]}"; do
    update-file $file_name $src_dir $dir
    echo
  done
done

popd > /dev/null
