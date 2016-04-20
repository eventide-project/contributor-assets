#!/usr/bin/env bash

${DRY_RUN:=true}

clear

set -e

echo
echo "Updating the License for Public Projects"
echo "= = ="
echo

source ./projects/other-public-projects.sh
source ./projects/ruby-public-projects.sh
source ./update-file.sh

working_copies=(
  "${other_public_projects[@]}"
  "${ruby_public_projects[@]}"
)

file_name="MIT-License.txt"

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
