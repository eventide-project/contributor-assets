#!/usr/bin/env bash

set -eEuo pipefail

if [ -f ~/device ]; then
  source ~/device
fi

if [ -z ${GITHUB_TOKEN+x} ]; then
  echo "GITHUB_TOKEN must be set"
  exit 1
fi

source ./projects/projects.sh

source ./github/milestones.sh

org_name='eventide-project'

repos=(
  "${projects[@]}"
)

echo
echo "Reconciling Milestones for $org_name"
echo "= = ="
echo

milestones=$(IFS=$'\n'; echo "${milestones[*]}")

for repo in "${repos[@]}"; do
  MILESTONES="$milestones" ORG_NAME=$org_name REPO=$repo github/reconcile_repo_milestones.rb
done

echo "- - -"
echo "(done)"
echo
