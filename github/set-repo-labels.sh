set -e

source ./github/labels.sh

function set-repo-labels {
  repo=$1
  org_name=$2
  github_token=$3

  echo "$repo"
  echo "- - -"

  delete-obsolete-labels "$repo" "$org_name" "$github_token"
  echo

  create-standard-labels "$repo" "$org_name" "$github_token"
  echo
}

function delete-obsolete-labels {
  repo=$1
  org_name=$2
  github_token=$3

  for obsolete_label in "${obsolete_labels[@]}"; do
    echo "Deleting $obsolete_label in $org_name/$repo"
    curl -s -u $github_token:x-oauth-basic -H "Accept: application/vnd.github.v3+json" --request DELETE https://api.github.com/repos/$org_name/$repo/labels/$obsolete_label > /dev/null
  done
}

function create-standard-labels {
  repo=$1
  org_name=$2
  github_token=$3

  for standard_label in "${standard_labels[@]}"; do
    echo "Creating standard label in $repo: $standard_label"
    curl -s -u $github_token:x-oauth-basic -H "Accept: application/vnd.github.symmetra-preview+json" --include --request POST --data "$standard_label" "https://api.github.com/repos/$org_name/$repo/labels" > /dev/null
  done
}

