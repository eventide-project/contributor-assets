function sed-i {
  if [ "$(uname)" = "Linux" ]; then
    sed -i "$@"
  else
    sed -i '' "$@"
  fi
}
