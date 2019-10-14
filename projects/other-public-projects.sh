set -e

database=(
  "postgres-message-store"
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
  "${administrative[@]}"
  "${tools[@]}"
  "${documentation[@]}"
)
