set -ue

if [ -z ${PROJECTS_HOME:-} ]; then
  echo "PROJECTS_HOME is not set"
  exit 1
fi

exclude_pattern=${1:-}

echo
echo -e "Running tests for each project (Exclude Pattern: ${exclude_pattern:-none})"
echo "= = ="
echo

source ./projects/ruby-projects.sh

projects=(
  "${ruby_public_gem_projects[@]}"
)

for dir in "${projects[@]}"; do
  if [[ -n $exclude_pattern && $dir =~ $exclude_pattern ]]; then
    echo "Excluded $dir"
    continue
  fi

  full_dir="$PROJECTS_HOME/$dir"

  pushd $full_dir

  if [ -f test/automated.rb ]; then
    rm -rf .bundle Gemfile.lock ./gems

    ./install-gems.sh

    ruby --disable-gems test/automated.rb
  fi

  popd
done
