set -e

source ./projects/ruby-public-gem-projects.sh
source ./projects/ruby-public-other-projects.sh

ruby_public_projects=(
  "${ruby_public_gem_projects[@]}"
  "${ruby_public_other_projects[@]}"
)
