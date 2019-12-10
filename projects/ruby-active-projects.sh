set -e

source ./projects/ruby-utility-projects.sh
source ./projects/ruby-core-projects.sh

ruby_active_projects=(
  "${ruby_utility_projects[@]}"
  "${ruby_core_projects[@]}"
)
