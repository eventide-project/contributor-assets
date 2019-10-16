set -e

database=(
  "postgres-message-store"
)

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
  "${database[@]}"
  "${npm[@]}"
  "${administrative[@]}"
  "${tools[@]}"
  "${documentation[@]}"
)
