set -e

tools=(
  "contributor-assets"
  "event-store-utils"
  "pg-stats"
)

documentation=(
  "docs"
  "docs-redirect"
  "useful-objects"
)

administrative=(
)

other_public_projects=(
  "${administrative[@]}"
  "${tools[@]}"
  "${documentation[@]}"
)
