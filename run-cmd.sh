function run-cmd {
  cmd=$1

  if [ "$DRY_RUN" = "true" ]; then
    echo "(DRY RUN) $cmd"
  else
    echo "$cmd"
  fi

  if [ "$DRY_RUN" != "true" ]; then
    ($cmd)
  fi
}
