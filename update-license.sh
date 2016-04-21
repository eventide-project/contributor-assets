#!/usr/bin/env bash

clear

set -e

if [ -z ${DRY_RUN+x} ]; then
  DRY_RUN=true
fi

echo
echo "Updating the License for Public Projects"
echo "= = ="
echo

source ./update-file.sh

# source ./projects/other-public-projects.sh
# source ./projects/ruby-public-projects.sh

# working_copies=(
#   "${other_public_projects[@]}"
#   "${ruby_public_projects[@]}"
# )

source ./projects/projects.sh
source ./run-cmd.sh

working_copies=(
  "${projects[@]}"
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
