set -e

function correct-repo-labels {
  repo=$1
  org_name=$2
  github_token=$3

  echo "$repo"
  echo "- - -"

  echo "Changing problem label"
  problem_color_data='{"color":"d91f0b","description":"Malfunction, bug, defect, aberration, irregularity, flaw, error, fault, and the like"}'
  curl -s -u $github_token:x-oauth-basic -H "Accept: application/vnd.github.symmetra-preview+json" --include --request PATCH --data "$problem_color_data" "https://api.github.com/repos/$org_name/$repo/labels/problem" > /dev/null

  echo "Creating mistake label"
  mistake_label_data='{"name":"mistake","description":"Something is not right or does not meet standards and needs correction","color":"ff4500"}'
  curl -s -u $github_token:x-oauth-basic -H "Accept: application/vnd.github.symmetra-preview+json" --include --request POST --data "$mistake_label_data" "https://api.github.com/repos/$org_name/$repo/labels" > /dev/null

  echo
}
