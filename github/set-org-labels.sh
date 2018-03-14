set -u

if [ -z ${DRY_RUN+x} ]; then
  DRY_RUN=false
fi

if [ -f ~/device ]; then
  source ~/device
fi

if [ -z ${GITHUB_TOKEN+x} ]; then
  echo "GITHUB_TOKEN must be set"
  exit 1
fi

source ./projects/projects.sh
source ./github/set-repo-labels.sh

org_name='eventide-project'

# repos=(
#   "${projects[@]}"
# )

# repos=(
#   "label-test"
# )

repos=(
  "eventide"
)

echo
echo "Setting Labels for $org_name"
echo "= = ="
echo

for repo in "${repos[@]}"; do
  set-repo-labels "$repo" "$org_name" "$GITHUB_TOKEN"
done

echo "= = ="

