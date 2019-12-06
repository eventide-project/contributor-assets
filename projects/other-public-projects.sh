set -e

npm=(
  "postgres-message-store-npm-package"
)

tools=(
  "contributor-assets"
  "event-store-utils"
)

documentation=(
  "docs"
  "useful-objects"
)

administrative=(
  "project-status"
)

other_public_projects=(
  "${npm[@]}"
  "${administrative[@]}"
  "${tools[@]}"
  "${documentation[@]}"
)
