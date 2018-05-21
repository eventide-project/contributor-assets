set -ue

if [ -z ${PROJECTS_HOME:-} ]; then
  echo "PROJECTS_HOME is not set"
  exit 1
fi

search_term=${1:-}

if [ -z "$search_term" ]; then
  echo "Error: search term not given"
  echo
  echo "Usage: $0 SEARCH_TERM"
  exit 1
fi

echo
echo -e "Searching projects for \"$search_term\""
echo "= = ="
echo

source ./projects/ruby-projects.sh

projects=(
  "${ruby_projects[@]}"
)

for dir in "${projects[@]}"; do
  full_dir="$PROJECTS_HOME/$dir"

  grep --exclude '*/gems/*' --exclude '*/.git/*' --exclude 'tags' -E -r -n "$search_term" $full_dir || true
done
