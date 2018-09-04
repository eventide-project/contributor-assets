set -e

tools=(
  "contributor-assets"
  "event-store-utils"
)

documentation=(
  "docs"
  "documentation-request"
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
