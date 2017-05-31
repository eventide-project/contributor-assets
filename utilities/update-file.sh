source ./utilities/run-cmd.sh

function update-file {
  file_name=$1
  src_dir=$2
  dest_dir=$3

  src="$src_dir/$file_name"
  dest="$dest_dir/$file_name"

  force=$(boolean-env-var FORCE)
  push=$(boolean-env-var PUSH)

  current_branch=$(git -C $dest_dir symbolic-ref -q --short HEAD)

  if $force; then
    echo "FORCE is $force. $dest will be updated regardless of whether it exists"
  else
    echo "FORCE is $force. $dest will only be updated if it exists"
  fi

  if $push; then
    echo "PUSH is $push. Updates be committed and pushed to origin master"
  else
    echo "PUSH is $push. Updates will not be committed and pushed to origin master"
  fi

  if [ -f $dest ]; then
    file_exists=true
    echo "$dest exists"
  else
    file_exists=false
    echo "$dest does not exist"
  fi

  if $file_exists; then
    if [ $dest -nt $src ]; then
      echo "$file_name is already up to date"
      echo "Not updating $dest with $file_name"
      return
    fi
  elif [ $force = "false" ]; then
    echo "$dest_dir does not have $file_name"
    echo "Not updating $dest with $file_name"
    return
  fi

  echo "Updating $dest from $src"

  pushd $dest_dir > /dev/null

  if $push; then
    echo "Current Branch: $current_branch"

    if [ $current_branch != "master" ]; then
      checkout_master_cmd="git checkout master"
      run-cmd "$checkout_master_cmd"
    fi
  fi

  copy_cmd="cp -v ../$src ./$file_name"
  run-cmd "$copy_cmd"

  if $push; then
    git_add_cmd="git add $file_name"
    run-cmd "$git_add_cmd"

    git_commit_cmd="git commit -m \"$file_name is updated with the latest version\""
    run-cmd "$git_commit_cmd"

    git_push_cmd="git push origin master"
    run-cmd "$git_push_cmd"

    if [ $current_branch != "master" ]; then
      co_crnt_cmd="git checkout $current_branch"
      run-cmd "$co_crnt_cmd"
    fi
  fi

  popd > /dev/null
}
