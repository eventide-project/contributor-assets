set -e

function correct-repo-labels {
  repo=$1
  org_name=$2
  github_token=$3

  echo "$repo"
  echo "- - -"

  # data='{"name":"entry level"}'
  # curl -s -u $github_token:x-oauth-basic -H "Accept: application/vnd.github.symmetra-preview+json" --include --request PATCH --data "$data" "https://api.github.com/repos/$org_name/$repo/labels/good%20first%20issue" > /dev/null

  echo "Removing help wanted label"
  curl -s -u $github_token:x-oauth-basic -H "Accept: application/vnd.github.v3+json" --request DELETE "https://api.github.com/repos/$org_name/$repo/labels/help%20wanted" > /dev/null

  echo
}
