set -e

function correct-repo-labels {
  repo=$1
  org_name=$2
  github_token=$3

  echo "$repo"
  echo "- - -"

  echo "Changing mistake label"
  data='{"color":"ff9500"}'
  curl -s -u $github_token:x-oauth-basic -H "Accept: application/vnd.github.symmetra-preview+json" --include --request PATCH --data "$data" "https://api.github.com/repos/$org_name/$repo/labels/mistake" > /dev/null

  echo
}
