set -e

source ./projects/ruby-public-projects.sh

ruby_projects=(
  "${ruby_public_projects[@]}"
)

if [ -e "./projects/ruby-private-projects.sh" ]; then
  source ./projects/ruby-private-projects.sh

  ruby_projects+=(
    "${ruby_private_projects[@]}"
  )
fi
