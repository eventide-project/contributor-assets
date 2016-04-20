source ./run-cmd.sh

function update-file {
  file_name=$1
  src_dir=$2
  dest_dir=$3

  src="$src_dir/$file_name"
  dest="$dest_dir/$file_name"

  if [ -z ${FORCE+x} ]; then
    FORCE=false
  fi

  echo "FORCE is $FORCE ($dest will only be updated if it exists)"

  if [ $FORCE = true ] || [ -f "$dest" ]; then

    if [ -f "$dest" ]; then
      echo "$dest exists"
    else
      echo "$dest does not exist"
    fi

    if [[ "$src" -nt "$dest" ]]; then
      echo "Updating $dest from $src"

      pushd $dest_dir > /dev/null
      pwd

      current_branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
      echo "Current Branch: $current_branch"

      if [ master != "$current_branch" ]; then
        checkout_master_cmd="git checkout master"
        run-cmd "$checkout_master_cmd"
      fi

      copy_cmd="cp -v ../$src ./"
      run-cmd "$copy_cmd"

      git_add_cmd="git add $file_name"
      run-cmd "$git_add_cmd"

      git_commit_cmd="git commit -m \"$file_name is updated with the latest version\""
      if [ "$DRY_RUN" = "true" ]; then
        echo "(DRY RUN) $git_commit_cmd"
      else
        echo "$git_commit_cmd"
        git commit -m "$file_name is updated with the latest version"
      fi

      git_push_cmd="git push origin master"
      run-cmd "$git_push_cmd"

      if [ master != "$current_branch" ]; then
        co_crnt_cmd="git checkout $current_branch"
        run-cmd "$co_crnt_cmd"
      fi

      popd > /dev/null
    else
      echo "$file_name is already up-to-date"
      echo "Not updating $dest with $file_name"
    fi
  else
    echo "$dest_dir does not have $file_name"
    echo "Not updating $dest with $file_name"
  fi
}
