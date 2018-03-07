set -e

obsolete_labels=(
  "suggestion"
  "enhancement"
  "bug"
  "problem"
  "feature"
  "duplicate"
  "feature"
  "invalid"
  "question"
  "consider"
  "consideration"
  "improvement"
  "imrpovement"
  "wontfix"
  "good%20first%20issue"
  "help%20wanted"
  "suggestion"
  "declined"
)

standard_labels=(
  '{"name":"feature","description":"Capability or functionality to be implemented","color":"0e8a16"}'
  '{"name":"problem","description":"Malfunction, bug, defect, or aberration that is wrong or suspected to be wrong or not working","color":"d93f0b"}'
  '{"name":"improvement","description":"Something that will be implemented to make an improvement or enhancement","color":"c2e0c6"}'
  '{"name":"suggestion","description":"A feature or a change you would like to have considered","color":"d4c5f9"}'
  '{"name":"consideration","description":"Potential to be an improvement or feature but needs more thought.","color":"c5def5"}'
  '{"name":"question","description":"A matter that requires clarification","color":"22f726"}'
  '{"name":"declined","description":"Does not reflect current or intended design or standards","color":"a5a5a5"}'
  '{"name":"duplicate","description":"A prior item exists or may exist for this matter","color":"e1e1e1"}'
  '{"name":"help wanted","description":"Looking for someone to take on the work, with guidance and stewardship from project principals","color":"d3fc62"}'
  '{"name":"good first issue","description":"Relatively straight-forward, provided guidance and stewardship from project principals","color":"5319e7"}'
)
