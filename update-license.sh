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
source ./run-cmd.sh

source ./projects/projects.sh

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
