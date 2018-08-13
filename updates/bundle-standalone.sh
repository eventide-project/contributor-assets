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

source projects/ruby-public-gem-projects.sh

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

function remove-file {
  file=$1
  project=$2

  pushd $project < /dev/null
  if [ -f "$file" ]; then
    echo "Removing $project/$file"

    rm_cmd="rm -vf $file"
    run-cmd "$rm_cmd"

    git_add_cmd="git add $file"
    run-cmd "$git_add_cmd"

    git_commit_cmd="git commit -m \"$file is removed\""
    run-cmd "$git_commit_cmd"

    git_push_cmd="git push origin master"
    run-cmd "$git_push_cmd"
  else
    echo "$project/$file is already removed; ignoring"
  fi
  popd < /dev/null
}

echo
echo "Splitting init.rb Into init.rb And load_path.rb For Ruby Projects"
echo "= = ="
echo

pushd $PROJECTS_HOME > /dev/null

for project in ${ruby_public_gem_projects[@]}; do
  echo $project
  echo "- - -"

  if [ -f $project/load_path.rb ]; then
    echo "Skipped (already has load_path.rb)"
  else
    update-file "load_path.rb" "contributor-assets/standardized" "$project"
    update-file "Gemfile" "contributor-assets/standardized" "$project"
    update-file "install_gems.sh" "contributor-assets/standardized" "$project"

    separate-init-rb-and-load-rb "$project"

    remove-file "set-local-gem-path.sh" "$project"
  fi

  echo
done

popd > /dev/null
