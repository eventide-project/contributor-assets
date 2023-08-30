set -u

if [ -f ~/device ]; then
  source ~/device
fi

if [ -z ${GITHUB_TOKEN+x} ]; then
  echo "GITHUB_TOKEN must be set"
  exit 1
fi

source ./projects/projects.sh

org_name='eventide-project'

original_milestone="v3"
milestone="Gen 3"

repos=(
  "${projects[@]}"
)

echo
echo "Renaming Milestone \"$original_milestone\" to \"$milestone\" for $org_name"
echo "= = ="
echo

for repo in "${repos[@]}"; do
  ORIGINAL_MILESTONE=$original_milestone MILESTONE=$milestone ORG_NAME=$org_name REPO=$repo github/rename_repo_milestone.rb
done

echo "- - -"
echo "(done)"
echo
