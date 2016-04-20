set -e

source ./projects/ruby-public-projects.sh

if [ -e "./projects/ruby-private-projects.sh" ]; then
  source ./projects/ruby-private-projects.sh
else
  ruby_private_projects=()
fi

ruby_projects=(
  "${ruby_public_projects[@]}"
  "${ruby_private_projects[@]}"
)
