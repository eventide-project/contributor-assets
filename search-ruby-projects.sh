set -ue

search_term=$1

echo
echo -e "Searching projects for \"$search_term\""
echo "= = ="
echo

source ./projects/ruby-projects.sh

projects=(
  "${ruby_projects[@]}"
)

for dir in "${projects[@]}"; do
  grep --exclude '*/gems/*' --exclude '*/.git/*' -E -r -n $search_term $dir || true
done
