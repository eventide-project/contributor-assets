#!/usr/bin/env bash

set -u

if [ -f ~/device ]; then
  source ~/device
fi

if [ -z ${GITHUB_TOKEN+x} ]; then
  echo "GITHUB_TOKEN must be set"
  exit 1
fi

source ./projects/projects.sh

source ./github/labels.sh

org_name='eventide-project'

repos=(
  "${projects[@]}"
)

echo
echo "Reconciling Labels for $org_name"
echo "= = ="
echo

labels=$(IFS=$'\n'; echo "${standard_labels[*]}")

for repo in "${repos[@]}"; do
  LABELS="$labels" ORG_NAME=$org_name REPO=$repo github/reconcile_repo_labels.rb
done

echo "- - -"
echo "(done)"
echo
