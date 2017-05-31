#!/usr/bin/env bash

set -eu

if [ -z ${DRY_RUN+x} ]; then
  DRY_RUN=true
fi

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

source utilities/update-file.sh
source utilities/run-cmd.sh

source projects/projects.sh

function extract-require-line {
  single_or_double_quote_pattern="['\"'\"'\\\"]"
  require_pattern="require[[:blank:]]+$single_or_double_quote_pattern.*$single_or_double_quote_pattern"
  print_require_line="print \$_ if /\A$require_pattern/ =~ \$_"

  IFS=$'
'
  require_lines=($(eval "ruby -n -e '$print_require_line' < init.rb"))
  unset IFS

  if [ ${#require_lines[@]} = 1 ]; then
    echo ${require_lines[0]}
  fi
}

function separate-init-rb-and-load-rb {
  echo

  echo "Updating library require line"

  pushd $project > /dev/null

  require_line=$(extract-require-line)

  if [ -z "$require_line" ]; then
    echo "Could not extract solitary require line from $project/init.rb"
    echo
    exit 1
  fi

  init_rb="require_relative './load_path'\\n\\n$require_line"

  echo "New init.rb:"
  echo
  echo "(start of file)"
  echo -e $init_rb
  echo "(end of file)"

  popd > /dev/null

  echo_cmd="echo -e \"$init_rb\" > init.rb"
  run-cmd "$echo_cmd"

  git_add_cmd="git add init.rb load_path.rb"
  run-cmd "$git_add_cmd"

  git_commit_cmd="git commit -m \"init.rb requires load_path.rb\""
  run-cmd "$git_commit_cmd"

  git_push_cmd="git push origin master"
  run-cmd "$git_push_cmd"
}

echo
echo "Splitting init.rb Into init.rb And load_path.rb For Ruby Projects"
echo "= = ="
echo

pushd $PROJECTS_HOME > /dev/null

for project in ${ruby_projects[@]}; do
  echo $project
  echo "- - -"

  update-file "load_path.rb" "contributor-assets/temp" "$project"
  separate-init-rb-and-load-rb "$project"

  echo
done

popd > /dev/null
