set -e

source ./projects/other-public-projects.sh

if [ -e "./projects/other-private-projects.sh" ]; then
  source ./projects/other-private-projects.sh
else
  other_private_projects=()
fi

other_projects=(
  "${other_public_projects[@]}"
  "${other_private_projects[@]}"
)
